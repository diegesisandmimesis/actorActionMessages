//
// actorActionMessages.h
//

#define sayTravelMessage(prop, args...) \
	if(getActionMessageObj().hasMessage(prop)) \
		getActionMessageObj().(prop)(##args); \
	else \
		inherited(##args);

#define ACTOR_ACTION_MESSAGES_H
