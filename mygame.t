#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID
    IFID = '558d20af-6559-477a-9f98-b7b4274cd304'
    name = 'Raid on Borderlands Station'
    byline = 'by Douglas Rapp'
    htmlByline = 'by <a href="mailto:douglas.rapp@gmail.com">
                  Douglas Rapp</a>'
    version = '1'
    authorEmail = 'Douglas Rapp<douglas.rapp@gmai.com>'
    desc = 'Escape the space cafe using external paper puzles'
    htmlDesc = 'Escape the space cafe using external paper puzles'
;

gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    
    showIntro()
    {
        "<b>Raid on Borderlands Station</b>\nThree months ago Borderlands
Station, once a thriving outpost on the edge of inhabited space, went dark. The
fate of the more than 3000 citizen and outlanders estimated to be aboard is
unknown, but the complete silence on all channels does not bode well. More
ominous, however, was that none of the ships known to be docked at the station
have been heard from either. The station was a patchwork mess to begin with,
and this far from civilization competent maintainers would be hard to come by.
Any number of accidents might have befallen the semi-legal smuggling outpost,
and that would be the end of it. Before too long another station held together
with glue and curses would have taken its place and that would be that. But
anything that could disable both the station and the ships silently, without a
teltale gigantic explosion, was a threat of a different order, and the galactic
protectorate had taken notice. You also took notice, and with your speedy ship
Pudding you've outpaced the official response by a solid week. And now the
station lies before you ready for plunder.<.p>
You are Stella Nova, famed rogue and general badass, and you know a profitable
situation when you see it. Whatever destroyed this station scares the
protectorate, and if you can get ahold of it the bidding war will be furous and profitable. You've left your ship behind, and now you're outside the station ready to face whatever you find inside.<.p>";
    }
;

startRoom: OutdoorRoom 'Station Entrance'
    "The outside of the space station stretches before you like a wall, the
curvature bearly noticable from this close up. You're at the main airlock door
a reinforced steel behemoth about four meters square. the rest of the hull is a jigsaw of weld patches, intricate but uninteresting, except for an outcropping 15 meters above you in your current reference frame. Behind you is the endless black of space, peppered by stars and the indistinguishable dot of your ship" 
    
    north = airlockDoor
    in asExit(north)
    up = hull
    cannotGoThatWayMsg = 'No sense wandering off, this station is enormous and you only have so much oxygen\b'
roomDescVerbose = nil
;

+ me: Actor
    pcDesc = "Stella Nova"
;

++ Container 'large white space bag*bags' 'space bag'
    "a bag, but in spaaace"
;

+ airlockDoor: LockableWithKey, Door 'large square steel station airlock' 'airlock'
    "This was the main entrance for individual human traffic in and out of the station. It's banged up, but no way you\'re prying this open. There's a keycard slot for entrance, wouldn't want anyone just wandering in here. "
    keyList = [keyCard]
    
    makeOpen(stat)
    {
        inherited(stat);
        if(stat)
            achievement.awardPointsOnce();
    }
    
    achievement: Achievement { +10 "opening the airlock door" }
        
;

hull: OutdoorRoom 'Hull'
    "You're on the hull on the side of the space station" 
    
    down = startRoom
    cannotGoThatWayMsg = 'No sense wandering off, this station is enormous and you only have so much oxygen\b'
roomDescVerbose = nil
;

+ loosePatch: ComplexContainer 'small steel hull plate patch' 
    'loose hull patch sticking out'
    "This bit of hull is loose, it doesn't seem to be essential for station integrity"
    subContainer: ComplexComponent, Container { bulkCapacity = 3}
    subUnderside: ComplexComponent, Underside { }
    dobjFor(Search) asDobjFor(Take)
    dobjFor(Pull) asDobjFor(Take)
    dobjFor(Open) asDobjFor(Take)

	actionDobjTake()  
	{  
      "It breaks off in your hand. ";
      inherited;
      "Never underestimate people's laziness when it comes to security. ";
    }
      
    
    bulk = 3
    bulkCapacity = 3
;

++ keyCard: Hidden, Key 'small plastic keycard*keycards' 'keycard'
    "a key card, used for entering things" 
    subLocation = &subUnderside 
;

+ Enterable -> airlockDoor 'large square steel station airlock' 'airlock'
    "It's a steel airlock door with a keycard slot for entering"

  destName = 'The airlock'
;

+ Decoration 'patch welds' 'welds'
    "This station is held together with glue and promises"
    
    notImportantMsg = 'They\'re welded shut, you don\'t have the equpiment to open them and you don\'t want to destroy the station'
    isPlural = true
;

terminal : Actor 'terminal' 'terminal'
  @airlock
  "A terminal screen with a speaker"
  properName = 'Terminal' 
  globalParamName = 'terminal'
  isIt = true
  initSpecialDesc = "A terminal sits on one wall. You should talk to it"
; 

+ ConvNode 'password-input'; 

++ SpecialTopic
  name = 'say the passphrase'
  keywordList = ['the', 'humans', 'are', 'prey']
  topicResponse {
      "PASSWORD ACCEPTED. DOOR UNLOCKED";
      airlockInnerDoor.makeLocked(nil);
  }
; 
 
++ DefaultAnyTopic "INVALID PASSWORD. YOU WILL BE EXTERMINATED";

+ terminalTalking : InConversationState
  stateDesc = "The terminal is flashing an ascii face" 
  specialDesc = "The terminal is ready for input"
;

++ terminalWorking : ConversationReadyState
  stateDesc = "The terminal is blank"
  isInitState = true
;

+++ HelloTopic, StopEventList
  [
    'A PASSPHRASE IS REQUIRED. \b
     14-10-16\b
     30-5-65\b
     39-4-38\b
     31-7-12\b<.convnode password-input>',
    'PLEASE GIVE THE PASSWORD <.convnode password-input>'
  ]
;

airlock: Room 'Airlock'
    "You are in the airlock, which is at the southern edge of the station according to local geography. The walls are boring and metalic, with pump nozzels in the corners to pump air in and out. "
    
    north = airlockInnerDoor
;

+ corpse:Fixture, Container 'dead desicated corpse' 'corpse'
    "The corpse of a station official is slumped against the side of the wall. His face stares at you with an expression of horror "
  initSpecialDesc = "The corpse of a station official is slumped against the side of the wall. His face stares at you with an expression of horror. You're momentarily startled, but you expected this, and at least it's not gruesome. You don't see any obvious cause of death"
;

++ catster: Hidden 'catster magazine' 'copy of Catster Magazine from Spring 2015'
 actionDobjTake()      
{
    inherited;
    "Strange that he would have such an ancient artifact. This magazine looks terrible, a rare phystical remnant from the BuzzFeed cultural black hole of the early 21st century";
}
;

+ airlockDoorInside : Lockable, Door -> airlockDoor 'door' 'door'; 

+ airlockInnerDoor: IndirectLockable, Door 'large square steel station airlock' 'airlock'
    "The airlock inner door is all that stands between you and the station"
    
    makeOpen(stat)
    {
        inherited(stat);
        if(stat)
            achievement.awardPointsOnce();
    }
    
    achievement: Achievement { +10 "opening the airlock door" }
        
;

+ Enterable -> airlockInnerDoor 'large square steel station airlock' 'airlock'
    "It's a steel airlock door"
;

atrium: DarkRoom 'Study'
    "This atrium is much as you would expect: somewhat spartan. A desk stands in
    the middle of the room with a chair placed just behind it. A <<if
      picture.moved>>safe is built into <<else>> rather bland painting hangs on
    <<end>> the west wall. The way out is to the east. "
    south = airlockInnerDoorInside
    out asExit(south)
    roomDarkDesc {"It's pitch black. Fortunately the last of the Grues were elimiated during the imperial succession war a century prior, or you'd be worried right now.<.p>
Your suit totally has a light on it, but for some reason, you're blanking on the voice command to activate it. Instead all you can think about is this weird puzzle labeled #2. ";}
;
+ airlockInnerDoorInside : Lockable, Door -> airlockInnerDoor 'door' 'door'; 


+ CustomImmovable, Chair 'red office swivel chair' 'chair'
    "It's a typical office swivel chair, covered in red fabric. "
    
    cannotTakeMsg = 'You see no reason to burden yourself with such a useless
        object; that would be quite unprofessional. '

;
    
+ picture: RoomPartItem, Thing 'rather bland picture/painting/landscape' 
    'picture'
    "It's a landscape, pleasantly executed enough, but of no great distinction
    and definitely not worth the bother of stealing. "
    
    initNominalRoomPartLocation = defaultWestWall
    initSpecialDesc = "A rather bland painting hangs on the west wall. "
    isListed = (moved)
    
    bulk = 8
    
    dobjFor(LookBehind)
    {
        action()
        {
            if(moved)
                inherited;
            else
            {
                safe.discover();
                "Behind the picture is a safe built into the wall. ";
            }
        }
    }
    
    moveInto(newDest)
    {
        if(!safe.discovered)
        {
            "Removing the painting from the wall reveals a safe behind. ";
            safe.discover();
        }
        inherited(newDest);
    }
;

+ safe: RoomPartItem, Hidden, CustomFixture, ComplexContainer 
    'sturdy steel safe' 'safe'
    "It's a sturdy steel safe with a single dial on its door. "
    
    subContainer: ComplexComponent, IndirectLockable, OpenableContainer 
    { 
        bulkCapacity = 5 
        makeOpen(stat)
        {
            inherited(stat);
            if(stat)
                achievement.awardPointsOnce();
        }
        
        achievement: Achievement { +10 "opening the safe" }        
    }
    
    specialDesc = "A safe is built into the west wall. "
    specialNominalRoomPartLocation = defaultWestWall
    cannotTakeMsg = "It's firmly built into the wall; you can't budge it. "
    
    discover()
    {
        if(!discovered)
        {
            foreach(local cur in allContents)
                cur.discover();
            
            achievement.awardPointsOnce();
        }
        inherited();
    }
    
    achievement: Achievement { +5 "finding the safe" }
;

++ safeDoor:  Hidden, ContainerDoor '(safe) door' 'safe door'
    "It has a circular dial attached to its centre. "         
;

+++ safeDial: Hidden, Component,  NumberedDial 'circular dial*dials' 'dial'
    "The dial can be turned to any number between <<minSetting>> and
    <<maxSetting>>. It's currently at <<curSetting>>. "
    
    minSetting = 0
    maxSetting = 99
    curSetting = '35'
    
    num1 = 0
    num2 = 0
    correctCombination = 1589
    
    makeSetting(val)
    {
        inherited(val);
        num2 = num1;
        num1 = toInteger(val);
        if(100 * num2 + num1 == correctCombination)
        {
            "You hear a slight <i>click</i> come from the safe door. ";
            safe.makeLocked(nil);
        }
        else if(!safe.isOpen)
            safe.makeLocked(true);
    }
;

++ orb: Thing 'ultimate battered dull metal orb/sphere/ball/satisfaction' 
    'Orb of Ultimate Satisfaction'
    "It doesn't look much be honest, just a battered sphere made of some dull
    metal, but you've been told it's the most valuable and desirable object 
    in the known universe! "
    
    aName = (theName)
    
    subLocation = &subContainer
    
    okayRubMsg = 'As {you/he} rub{s} {the dobj/him} a shimmering djiin suddenly
        appears in the air before you!\b 
        <q>Hello, you have reached the automated holographic answering service
        of Jeannie the Genie,</q> she announces. <q>I\'m sorry I\'m not
        available to respond to your rub in person right now, but my hours of
        activity have been heavily curtailed by the European Working Time
        Directive. Before making a wish, please make sure that you have
        conducted a full risk assessment in line with the latest Health and
        Safety Guidelines. Also, please note that before any wish can be granted
        you must sign a Form P45/PDQ/LOL indemnifying this wish-granting agency
        against any consequential loss or damage arising from the fulfilment of
        your desires. Thank you for rubbing. Have a nice day!</q>\b
        Her message complete, the holographic djiin fades away into
        non-existence. '
    
    moveInto(dest)
    {
        inherited(dest);
        if(dest.isOrIsIn(me))
            achievement.awardPointsOnce();
    }
    
    achievement: Achievement { +10 "taking the orb" }
;

//------------------------------------------------------------------------------

/* DEFINE A NEW VERB */

DefineTAction(Rub)
;

VerbRule(Rub)
    'rub' dobjList
    : RubAction
    verbPhrase = 'rub/rubbing (what)'
;

/* When creating a new verb, you'll want to modify the Thing class so as to provide
   default handling for the command. The defaults specified here will be used except
   on objects for which you define explicit handling of the command. */
   
modify Thing
    dobjFor(Rub)
    {
        preCond = [touchObj]
        action() { mainReport(okayRubMsg); }        
    }
    
    okayRubMsg = '{You/he} rub{s} {the dobj/him} but not much happens as a
        result. '
    
    shouldNotBreakMsg = 'Only amateurs go round breaking things unnecessarily. '    
;

//------------------------------------------------------------------------------

DefineIAction(FiatLux)
 execAction
{
  if(gPlayerChar.brightness == 0)
  {
    "Your suit light switches on and you can see again\n";
    gPlayerChar.brightness = 3;
  }
  else
  {
    "You switch your suit light on. ";
    gPlayerChar.brightness = 0;
  }
}
;

VerbRule(FiatLux)
  'fiat' 'lux'
  : FiatLuxAction
  verbPhrase = 'make/making light'
; 
