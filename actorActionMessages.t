#charset "us-ascii"
//
// actorActionMessages.t
//
//	A TADS3/adv3 module providing per-actor action message objects.
//
//
// USAGE
//
//	The module provides three classes:
//
//		ActorActionMessages
//			Based on MessageHelper, this probably shouldn't
//			be used unless you're planning on customizing
//			literally ALL of the actor's action messages.
//
//		PlayerActionMessages
//			For player characters.  Uses playerActionMessages
//			as its base.
//
//		NPCActionMessages
//			For NPCs.  Uses npcActionMessages as its base.
//
//	To use one, just add it to an actor object:
//
//		// Declare an actor
//		alice: Person 'Alice' 'Alice'
//			"She looks like the first person you'd turn to in
//			a problem. "
//			isProperName = true
//			isHer = true
//		;
//		// Add the action message object
//		+NPCActionMessages
//			okayTakeMsg = '{You/he} carefully take{s}
//			{the dobj/him}. '
//		;
//
//	In this case, whenever Alice TAKEs an object, instead of the default
//	"Alice takes the pebble.", you'd get "Alice carefully takes the pebble."
//
//
//
#include <adv3.h>
#include <en_us.h>

#include "actorActionMessages.h"

// Module ID for the library
actorActionMessagesModuleID: ModuleID {
        name = 'Actor Action Messages Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

actorActionMessagesPreinit: PreinitObject
	execute() {
		forEachInstance(ActorActionMessages, function(o) {
			o.initializeActorActionMessages();
		});
	}
;

modify Actor
	actorActionMessageObj = nil

	addActorActionMessages(obj) {
		if((obj == nil) || !obj.ofKind(ActorActionMessages))
			return(nil);
		actorActionMessageObj = obj;
		return(true);
	}

	getActionMessageObj() {
		local st;

		if(actorActionMessageObj != nil)
			return(actorActionMessageObj);
		if(curState != nil) {
			if((st = curState.getActionMessageObj()) != nil)
				return(st);
		}
		return(inherited());
	}

	// Returns true if the actor's action message object has
	// the given property.
	actionMessageObjHasMessage(prop) {
		return(getActionMessageObj().hasMessage(prop));
	}
;

modify ActorState
	actorActionMessageObj = nil

	addActorActionMessages(obj) {
		if((obj == nil) || !obj.ofKind(ActorActionMessages))
			return(nil);
		actorActionMessageObj = obj;
		return(true);
	}

	getActionMessageObj() {
		if(actorActionMessageObj != nil)
			return(actorActionMessageObj);
		return(inherited());
	}
;

// Base class.  Probably shouldn't be used unless you're planning on
// replacing EVERY action message for the actor.
class ActorActionMessages: MessageHelper
	initializeActorActionMessages() {
		if(location == nil)
			return;
		if(!location.ofKind(Actor) && !location.ofKind(ActorState))
			return;
		location.addActorActionMessages(self);
	}

	// Returns true if the message object has the given property
	// defined.
	hasMessage(prop) {
		return(self.propDefined(prop, PropDefDirectly)
			&& (propType(prop) != TypeNil));
	}
;

// For player characters.
class PlayerActionMessages: ActorActionMessages, playerActionMessages;

// For NPCs.
class NPCActionMessages: ActorActionMessages, npcActionMessages;

#ifndef ACTOR_ACTION_MESSAGES_TRAVEL

modify Actor
	sayArriving([args]) { sayTravelMessage(&sayArriving, args...); }
	sayDeparting([args]) { sayTravelMessage(&sayDeparting, args...); }
	sayArrivingLocally([args])
		{ sayTravelMessage(&sayArrivingLocally, args...); }
	sayDepartingLocally([args])
		{ sayTravelMessage(&sayDepartingLocally, args...); }
	sayTravelingRemotely([args])
		{ sayTravelMessage(&sayTravelingRemotely, args...); }
	sayArrivingDir([args]) { sayTravelMessage(&sayArrivingDir, args...); }
	sayDepartingDir([args]) { sayTravelMessage(&sayDepartingDir, args...); }
	sayArrivingThroughPassage([args])
		{ sayTravelMessage(&sayArrivingThroughPassage, args...); }
	sayDepartingThroughPassage([args])
		{ sayTravelMessage(&sayDepartingThroughPassage, args...); }
	sayArrivingViaPath([args])
		{ sayTravelMessage(&sayArrivingViaPath, args...); }
	sayDepartingViaPath([args])
		{ sayTravelMessage(&sayDepartingViaPath, args...); }
	sayArrivingUpStairs([args])
		{ sayTravelMessage(&sayArrivingUpStairs, args...); }
	sayArrivingDownStairs([args])
		{ sayTravelMessage(&sayArrivingDownStairs, args...); }
	sayDepartingUpStairs([args])
		{ sayTravelMessage(&sayDepartingUpStairs, args...); }
	sayDepartingDownStairs([args])
		{ sayTravelMessage(&sayDepartingDownStairs, args...); }
;

#endif // ACTOR_ACTION_MESSAGES_TRAVEL
