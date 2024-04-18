#charset "us-ascii"
//
// actorActionMessages.t
//
#include <adv3.h>
#include <en_us.h>

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
		if(actorActionMessageObj != nil)
			return(actorActionMessageObj);
		return(inherited());
	}
;

class ActorActionMessages: MessageHelper
	initializeActorActionMessages() {
		if((location == nil) || !location.ofKind(Actor))
			return;
		location.addActorActionMessages(self);
	}
;

class PlayerActionMessages: ActorActionMessages, playerActionMessages;
class NPCActionMessages: ActorActionMessages, npcActionMessages;
