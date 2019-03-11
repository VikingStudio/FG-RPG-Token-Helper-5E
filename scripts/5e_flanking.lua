--  Please see the COPYRIGHT.txt file included with this distribution for attribution and copyright information.


-- check for flanking advantage for melee attack
-- use: local bFlanking = isFlanking(rActor, rTarget);
-- pre: bFlanking = false
-- post: returns true if  actor has a flanking attack on target flanking, else false
function isFlanking(rActor, rTarget)
	local bFlanking = false;	

	-- get token map and actor grid location
	local ctrlImage = TokenHelper.getControlImageByActor(rActor);
	local aTokenMap = TokenHelper.getTokenMap(ctrlImage);		
	
	--[[
		Design doc:
		first get attack direction from attacker to target (N, NE, E, SE, S, SW, W, NW)
		check for target size, as this determines in what squares flanking ally can be
		if attacker from NE, SE, SW, NW corners, then only the very opposite square offer advantage
		if attacker attacking from any side square, then if ally in any opposite square offers advantage
			this translates for sizes:
				Medium or smaller: 1 opposite square
				Large:  2 opposite squares
				Huge:   3 opposite squares
				Gargantuan: 4 opposite squares						
		Search for ally that is not unconscious/paralyzed/petrified/stunned/prone/restrained in those squares.
		Check for altitude differences between actor, target and ally to make sure within range of melee.
		If such an ally is fund, return bFlanking as true (take that result and apply an advantage outside of this function if appropriate)
	]]--

	-- find attack direction
	local actorX = aTokenMap[rActor.sName].gridx;
	local actorY = aTokenMap[rActor.sName].gridy;
	local targetX = aTokenMap[rTarget.sName].gridx;
	local targetY = aTokenMap[rTarget.sName].gridy;
	
	
	-- determine direction of attack and set sDirection to N, NE, E, SE, S, SW, W, NW.
	local sDirection;
	if aTokenMap[rTarget.sName].size == 'Medium' or aTokenMap[rTarget.sName].size == 'Small' or aTokenMap[rTarget.sName].size == 'Tiny' then
		if (actorX == targetX) and (actorY == targetY + 1) then sDirection = 'N'; end
		if (actorX == targetX - 1) and (actorY == targetY + 1) then sDirection = 'NE'; end	
		if (actorX == targetX - 1) and (actorY == targetY) then sDirection = 'E'; end
		if (actorX == targetX - 1) and (actorY == targetY - 1) then sDirection = 'SE'; end
		if (actorX == targetX) and (actorY == targetY - 1) then sDirection = 'S'; end
		if (actorX == targetX + 1) and (actorY == targetY - 1) then sDirection = 'SW'; end
		if (actorX == targetX + 1) and (actorY == targetY) then sDirection = 'W'; end					
		if (actorX == targetX + 1) and (actorY == targetY + 1) then sDirection = 'NW'; end												 
	end
	if aTokenMap[rTarget.sName].size == 'Large' then
	end	

	-- search for ally
	local sAllyName = '';
	if aTokenMap[rTarget.sName].size == 'Medium' or aTokenMap[rTarget.sName].size == 'Small' or aTokenMap[rTarget.sName].size == 'Tiny' then	
		if sDirection == 'N' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX, targetY - 1);	end
		if sDirection == 'NE' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX + 1, targetY - 1); end
		if sDirection == 'E' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX + 1, targetY);	end
		if sDirection == 'SE' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX + 1, targetY + 1); end
		if sDirection == 'S' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX, targetY + 1);	end
		if sDirection == 'SW' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX - 1, targetY + 1); end
		if sDirection == 'W' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX - 1, targetY);	end
		if sDirection == 'NW' then sAllyName = TokenHelper.getActorByGrid(aTokenMap, targetX - 1, targetY - 1); end
	end
	
	-- get ally CT entry
	local allyNodePath = '';
	local aEntries = CombatManager.getSortedCombatantList();	    	
	local nIndexActive = 0;	
    for i = nIndexActive + 1, #aEntries do                           
        if DB.getText(aEntries[i], 'name') == sAllyName then allyNodePath = aEntries[i]; end				
		nIndexActive = nIndexActive + 1;     
	end	

	-- consider altitude
	-- get nodes -> tokens -> token height
	local actorNode = rActor.sCTNode;
    local targetNode = rTarget.sCTNode;		        
    local allyNode = CombatManager.getCTFromNode(allyNodePath);  

	local actorToken = CombatManager.getTokenFromCT(actorNode);
	local targetToken = CombatManager.getTokenFromCT(targetNode);	
    local allyToken = CombatManager.getTokenFromCT(allyNode);        

	-- get height
	local actorHeight = HeightManager.getCTHeight(actorToken);
	local targetHeight = HeightManager.getCTHeight(targetToken);	
	local allyHeight = HeightManager.getCTHeight(allyToken);

	-- if either actor or ally are out of range of melee attack, height wise, then no flanking benefit
	local bOutOfRange = false;
	if (math.sqrt(actorHeight^2 - targetHeight^2) > 5) or (math.sqrt(allyHeight^2 - targetHeight^2) > 5) then bOutOfRange = true; end				

	local actorFriendFoe = aTokenMap[rActor.sName].friendfoe;
	local allyFriendFoe = '';
	if sAllyName ~= '' then allyFriendFoe = aTokenMap[sAllyName].friendfoe; end
	
	-- set bFlanking=true, if a flanking ally is found that is not unconscious/paralyzed/petrified/prone/stunned/restrained
	if actorFriendFoe == allyFriendFoe then 	
		local node = aTokenMap[sAllyName].node;
		local bAllyDisabled = TokenHelper.isActorDisabled5e(node);
		if (bAllyDisabled == false) and (allyNodePath ~= '')
		then
			bFlanking = true;
		end	
	end

	if bOutOfRange == true then bFlanking = false; end
			
	return bFlanking;
end