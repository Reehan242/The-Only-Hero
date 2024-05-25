extends Node

var level = 1
var xp = 0.0
var xp_bracket = [250, 400, 600, 1000, 1500 , 2500]

func addexp(xp_points):
	if level < xp_bracket.size() - 1:                   	#Check if we are at level cap
		xp += xp_points                                 	#Add experience points
		while (xp > xp_bracket[level]):  					#while we are above the exp cap
			xp -= xp_bracket[level]      					#take away experience = to the cap
			level += 1	                                	#increase level
		if level >= xp_bracket.size() - 1:              	#if we reach level cap
			xp = 0.0	                                	#change experience to 0
	else:
		xp = 0.0	                                    	#make experience 0 if at level cap
