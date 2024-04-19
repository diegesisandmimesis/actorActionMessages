#charset "us-ascii"
//
// travelTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the actorActionMessages library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f travelTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "actorActionMessages.h"

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

class WanderAgenda: AgendaItem
	agendaOrder = 99
	initiallyActive = true
	isReady() { return(true); }
	invokeItem() {
		if(rand(100) > 50)
			return;
		if(getActor().location == northRoom)
			newActorAction(getActor(), South);
		else
			newActorAction(getActor(), North);
	}
;

southRoom: Room 'South Room'
	"This is the South Room.  The North Room lies to the north. "
	north = northRoom
;
+me: Person;
+pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isProperName = true
	isHer = true
;
++NPCActionMessages
	sayArriving(conn) { "{You/he} enter{s} slowly <<travelerLocName>>. "; }
	sayArrivingDir(dir, conn) {
		"{You/he} enter{s} slowly <<travelerLocName>> from the
			<<dir.name>>. ";
	}
;
++WanderAgenda;

+bob: Person 'Bob' 'Bob'
	"He looks like a Robert, only shorter. "
	isProperName = true
	isHim = true
;
++WanderAgenda;

northRoom: Room 'North Room'
	"This is the North Room.  The South Room is south of here. "
	south = southRoom
;
