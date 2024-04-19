#charset "us-ascii"
//
// stateTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the actorActionMessages library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f stateTest.t3m
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

modify npcActionMessages
	pebbleCheck = '{You/he} casually glances at the pebble. '
;

class PebbleAgenda: AgendaItem
	agendaOrder = 99
	initiallyActive = true
	isReady() { return(pebble.location == getActor().location); }
	invokeItem() {
		if(rand(100) > 25) {
			mainReport(&pebbleCheck);
			return;
		}
		newActorAction(getActor(), Take, pebble);
	}
;

startRoom: Room 'Void'
	"This is a featureless void."
	pebbleCounter = 0
	roomDaemon() {
		pebbleCheck();
	}
	pebbleCheck() {
		if(pebble.location == self)
			return;
		pebbleCounter += 1;
		if(pebbleCounter > 3)
			pebbleReset();
	}
	pebbleReset() {
		local holder;

		if((holder = pebble.getCarryingActor()) == nil)
			return;

		gMessageParams(holder);
		mainReport('The room daemon moves <<pebble.theName>>
			from {the\'s holder/her} inventory and into
			the room. ');

		pebble.moveInto(self);
		pebbleCounter = 0;
	}
;
+me: Person;
+pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isProperName = true
	isHer = true
;
++PebbleAgenda;
++ActorState
	isInitState = true
;
+++NPCActionMessages
	okayTakeMsg = '{You/he} carefully take{s} {the dobj/him}. '
	pebbleCheck = '{You/he} eye{s} the pebble, but take{s} no action. '
;
