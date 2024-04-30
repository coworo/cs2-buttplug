let maincontrol = 1.0; // 0.0-1.0 sets the maximum strength

//fn get(blob: Blob, index: int) -> int;

let PremierC = #{ //settings for gamemode
    stopwhennewround:1, //0,1 stop immediately when round counter advances
    effectismomentary:0, //0,1 0:effect lasts for the round duration 1:effect lasts for vibduration in seconds
    momentarystyle:1, //1,2 1: strength increases through the match. 2: strength increases through the round
    momentarymultipler:1.0, //0.0-1.0 if momentary effect is multiplied
    vibduration:1.0, //0.0-1.0duration of momentary effect
    kpreffects:1, //0,1 kills per round effects
    kprstrength:10.0, //One kill = 1%, most devices operate on 5% increments
    flasheffects:1, //0,1 being flashed effects (proprotional to blindness)
    flashstrength:1.0, //multiplied by percentage of status
    smokeeffects:1, //0,1 being in smoke effects (proportional to coverage)
    smokestrength:0.2, //multiplied by percentage of status
    bombeffects:1, //0,1 routine changes after bomb plant
    bombtickingeffectstrength:0.1, //0.0-1.0
    bombtickingeffectduration:0.2, //0.0-inf in seconds
    bomb10seceffectstrength:0.5,
    bomb10seceffectduration:0.3,
};

let CompetitiveC = #{ //settings for gamemode
    stopwhennewround:1, //0,1 stop immediately when round counter advances
    effectismomentary:0, //0,1 0:effect lasts for the round duration 1:effect lasts for vibduration in seconds
    momentarystyle:1, //1,2 1: strength increases through the match. 2: strength increases through the round
    momentarymultipler:1.0, //0.0-1.0 if momentary effect is multiplied
    vibduration:1.0, //0.0-1.0duration of momentary effect
    kpreffects:1, //0,1 kills per round effects
    kprstrength:10.0, //One kill = 1%, most devices operate on 5% increments
    flasheffects:1, //0,1 being flashed effects (proprotional to blindness)
    flashstrength:1.0, //multiplied by percentage of status
    smokeeffects:1, //0,1 being in smoke effects (proportional to coverage)
    smokestrength:0.2, //multiplied by percentage of status
    bombeffects:1, //0,1 routine changes after bomb plant
    bombtickingeffectstrength:0.1, //0.0-1.0
    bombtickingeffectduration:0.2, //0.0-inf in seconds
    bomb10seceffectstrength:0.5,
    bomb10seceffectduration:0.3,
};

let CasualC = #{ //settings for gamemode
    stopwhennewround:1, //0,1 stop immediately when round counter advances
    effectismomentary:0, //0,1 0:effect lasts for the round duration 1:effect lasts for vibduration in seconds
    momentarystyle:1, //1,2 1: strength increases through the match. 2: strength increases through the round
    momentarymultipler:1.0, //0.0-1.0 if momentary effect is multiplied
    vibduration:1.0, //0.0-1.0duration of momentary effect
    kpreffects:1, //0,1 kills per round effects
    kprstrength:10.0, //One kill = 1%, most devices operate on 5% increments
    flasheffects:1, //0,1 being flashed effects (proprotional to blindness)
    flashstrength:0.2, //multiplied by percentage of status
    smokeeffects:0, //0,1 being in smoke effects (proportional to coverage)
    smokestrength:0.1, //multiplied by percentage of status
    bombeffects:1, //0,1 routine changes after bomb plant
    bombtickingeffectstrength:0.05, //0.0-1.0
    bombtickingeffectduration:0.1, //0.0-inf in seconds
    bomb10seceffectstrength:0.1,
    bomb10seceffectduration:0.2,
};
let DeathmatchC = #{ //settings for gamemode
    stopwhennewround:1, //0,1 stop immediately when round counter advances
    effectismomentary:1, //0,1 0:effect lasts for the round duration 1:effect lasts for vibduration in seconds
    momentarystyle:1, //1,2 1: strength increases through the match. 2: strength increases through the round
    momentarymultipler:1.0, //0.0-1.0 if momentary effect is multiplied
    vibduration:0.5, //0.0-1.0 duration of momentary effect
    kpreffects:1, //0,1 kills per round effects
    kprstrength:5.0, //One kill = 1%, most devices operate on 5% increments
    flasheffects:0, //0,1 being flashed effects (proprotional to blindness)
    flashstrength:1.0, //multiplied by percentage of status
    smokeeffects:0, //0,1 being in smoke effects (proportional to coverage)
    smokestrength:0.2, //multiplied by percentage of status
    bombeffects:0, //0,1 routine changes after bomb plant
    bombtickingeffectstrength:0.1, //0.0-1.0
    bombtickingeffectduration:0.2, //0.0-inf in seconds
    bomb10seceffectstrength:0.5,
    bomb10seceffectduration:0.3,
};

//internal use vars
let vib = 0.0;
let vibk = 0.0;
let vibf = 0.0;
let vibs = 0.0;
let kills = 0;
let currentround;
let currentbomb;
let secondts = -1.0;
let a;
let planttime = timestamp();
let gvar = 0.0; //not used
let gvib = 0.0; //not used
let lastvib = 0.0;
let dontspam = 0.0;



fn stopconditions() {
    if conf.stopwhennewround == 1 && roundphase == "Over" {return 1;}
    if playeractivity == "Menu" {return 1;}
    if playerstatehealth == 0.0 {return 1;}
    return 0;
}

fn globaladd(a) {this = this + a;}
fn globaladvance() {this += 1.0}
fn globalreset() {this = 0.0}
fn globalset() {this = timestamp();}


//handles () by zeroing it and same type by passing it
fn initstringvar(updatecall) {let x; if type_of(updatecall) == "string" {x = updatecall;} else if updatecall != () {x = updatecall.to_string();} else {x = "";} return x;}
fn initintvar(updatecall) {let x; if type_of(updatecall) == "i64" || type_of(updatecall) == "i32" {x = updatecall;} else if updatecall != () {x = updatecall.to_int();} else {x = 0;} return x;}
fn initfloatvar(updatecall) {let x; if type_of(updatecall) == "f64" || type_of(updatecall) == "f32" {x = updatecall;} else if updatecall != () {x = updatecall.to_float();} else {x = 0.0;} return x;}


    
fn handle_update(update) {
    
    if update.player != () && update.map != () && update.round != () {
        if update.player.match_stats != () {
            let now = timestamp();
            
            let mapmode = initstringvar(update.map.mode); //Casual, Deathmatch, Competitive, ArmsRace, Wingman
            let mapphase = initstringvar(update.map.phase); //Live, GameOver, Intermission, Warmup
            let mapname = initstringvar(update.map.name); //xx_mapname
            let playeractivity = initstringvar(update.player.activity); //Playing, Menu,

            let mapround = initintvar(update.map.round); //updates immediately
            let playerteam = initstringvar(update.player.team); //CT, T
            let roundphase = initstringvar(update.round.phase); //Live, Over, Freezetime. Immediately updates. HANGS IN TEAM SELECT
            let roundbomb = initstringvar(update.round.bomb); //Planted, Defused, Exploded, (). !useful

            let playerstateround_kills = initfloatvar(update.player.state.round_kills); //updates to 0 immediately when dead, waits for next round when succesful round
            let playerstateround_totaldmg = initfloatvar(update.player.state.round_totaldmg); //NOP, empty
            let playerstateround_killhs = initfloatvar(update.player.state.round_killhs); //probably same with round_kills

            let playermatch_statskills = initfloatvar(update.player.match_stats.kills); //match wide, doesnt reset until first round of next match *ends*
            let playermatch_statsdeaths = initfloatvar(update.player.match_stats.deaths); //match wide, doesnt reset until first round of next match *ends*
            let playermatch_statsassists = initfloatvar(update.player.match_stats.assists); //match wide, doesnt reset until first round of next match *ends*

            let playermatch_statsmvps = initfloatvar(update.player.match_stats.mvps); //match wide, doesnt reset until first round of next match *ends*
            let playermatch_statsscore = initfloatvar(update.player.match_stats.score); //match wide, doesnt reset until first round of next match *ends*
             
            let playerstatehealth = initfloatvar(update.player.state.health)/100.0; //0-100. converted to 0.0-1.0 float
            let playerstatearmor = initfloatvar(update.player.state.armor)/100.0;  //0-100 converted to 0.0-1.0 float
            let playerstatehelmet = initstringvar(update.player.state.helmet); //true, false 
            let playerstateflashed = initfloatvar(update.player.state.flashed)/255.0; //0-255 !useful converted to 0.0-1.0 float
            let playerstatesmoked = initfloatvar(update.player.state.smoked)/255.0; //0-255 converted to 0.0-1.0 float
            let playerstateburning = initfloatvar(update.player.state.burning)/255.0; //0-255 converted to 0.0-1.0 float
            let playerstatedefusekit = initstringvar(update.player.state.defuse_kit); //true, false
            let planttimeelapsed = initfloatvar(planttime.elapsed);
            
            //let playerweaponammoreserve = update.player.weapon.ammo_reserve; //NOP, error. nothing in player.weapon works. should be the correct syntax?

            /* no one needs these for this application, but just in case.
            let maproundwins = update.map.round_wins; //json format round explanations
            let mapteamctscore = update.map.team_ct.score; //ct round win amount
            let mapteamtscore = update.map.team_t.score; //t round win amount
            let mapteamcttimeoutsremaining = update.map.team_ct.timeouts_remaining;
            let mapteamttimeoutsremaining = update.map.team_ct.timeouts_remaining;
            let mapteamctname = update.map.team_ct.name;
            let mapteamtname = update.map.team_ct.name;
            let mapteamctflag = update.map.team_ct.flag;
            let mapteamtflag = update.map.team_ct.flag;
            */
            
            //print("++++++++"+"\n"+"\tmapmode:"+mapmode+" \tmapphase:"+mapphase+" \tmapname:"+mapname+" \tplayeractivity:"+playeractivity+"\n"+" \tmapround:"+mapround+" \tplayerteam:"+playerteam+" \troundphase:"+roundphase+" \troundbomb:"+roundbomb+"\n\n"+" \tplayerstateround_kills:"+playerstateround_kills+" \tplayerstateround_totaldmg:"+playerstateround_totaldmg+" \tplayerstateround_killhs:"+playerstateround_killhs+"\n"+" \tplayermatch_statskills:"+playermatch_statskills+" \tplayermatch_statsdeaths:"+playermatch_statsdeaths+" \tplayermatch_statsassists:"+playermatch_statsassists+"\n"+" \tplayermatch_statsmvps:"+playermatch_statsmvps+" \tplayermatch_statsscore:"+playermatch_statsscore+"\n\n"+" \tplayerstatehealth:"+playerstatehealth+" \tplayerstatearmor:"+playerstatearmor+" \tplayerstatehelmet:"+playerstatehelmet+"\n"+" \tplayerstateflashed:"+playerstateflashed+" \tplayerstatesmoked:"+playerstatesmoked+" \tplayerstateburning:"+playerstateburning+" \tplayerstatedefusekit:"+playerstatedefusekit+"\n"+"\tplanttime.elapsed: "+planttimeelapsed+"\n--------");
            
            let conf = eval(mapmode+"C");
            //print(conf);

            let stopcondition = initfloatvar(stopconditions!());
            //if stopcondition == 1.0 {mapmode = "Menu";} //menu doesnt exist so no vibration without spamming stop
            //if lastvib == 0.0 && vib == 0 {mapmode = "Menu";}
            

            if currentbomb != roundbomb {
                //bombstatechanged
                if roundbomb == "Planted" {
                    //bombstate changed and become planted
                    //print("BOMB PLANTED!");
                    planttime.globalset();
                    secondts.globalreset();
                    gvar.globaladvance();
                }
            }
            currentbomb = roundbomb;

            if currentround < mapround {gvar.globalreset();}
            currentround = mapround;



            //vibration calculations start here
            if conf.kpreffects == 1 {vibk = (playerstateround_kills/100.0)*conf.kprstrength;}
            //if conf.apreffects == 1 {vib = vib + roundassists/10.0;} //thinking
            if conf.flasheffects == 1 {vibf = playerstateflashed*conf.flashstrength;}
            if conf.smokeeffects == 1 {vibs = playerstatesmoked*conf.smokestrength;}
            if conf.bombeffects == 1 && roundbomb == "Planted" { //bombeffects is active and bomb is planted
                if planttime.elapsed >= secondts + 1.0 {    //run it every second
                    secondts.globaladd(1.0);                                        
                    if planttime.elapsed <30.0 {            //first 30 seconds of bomb countdown
                        vibratefor(conf.bombtickingeffectstrength*maincontrol, conf.bombtickingeffectduration);
                    } else {                                 //last 10 seconds of bomb countdown
                        vibratefor(conf.bomb10seceffectstrength*maincontrol, conf.bomb10seceffectduration);         
                    }
                }
            } 
            else {
                print("not in bombeffect");
                if conf.effectismomentary == 1 && dontspam == 0.0{
                    print("momentary");
                    vibrate((vibf+vibs)*maincontrol*conf.momentarymultipler);
                    if conf.momentarystyle == 1 {
                        print("in momentary style 1");
                        if kills < update.player.match_stats.kills {
                            let kdiff = (update.player.match_stats.kills - kills);
                            if kdiff > 5 {kdiff = 5;}
                            for i in range(0, kdiff) {
                                //vibrate_index(kills.to_float()/50.0, 1.0, (kills + i) % 2); //"index is not device index, rather device motor index. is this intentional?" 
                                vibratefor(kills.to_float()*maincontrol*conf.momentarymultipler/50.0, 1.0);
                                //print(kills.to_float()*maincontrol*conf.momentarymultipler/50.0);
                            }
                            kills = update.player.match_stats.kills;
                        }
                    }
                    else { //style2
                        print("in momentary style 2");
                        if kills < update.player.match_stats.kills {
                            let kdiff = (update.player.match_stats.kills - kills);
                            if kdiff > 5 {kdiff = 5;}
                            for i in range(0, kdiff) {
                                //vibrate_index(kills.to_float()/50.0, 1.0, (kills + i) % 2); //"index is not device index, rather device motor index. is this intentional?" 
                                vibratefor(playerstateround_kills*conf.kprstrength*maincontrol*conf.momentarymultipler/100.0, conf.vibduration);
                                }
                                kills = update.player.match_stats.kills;   

                            }
                        }
                } 
                else {
                    print("not momentary");   
                    if conf.kpreffects == 1 {vibk = (playerstateround_kills/100.0)*conf.kprstrength;}
                    //if apreffects == 1 {vib = vib + roundassists/10.0;} //thinking
                    if conf.flasheffects == 1 {vibf = playerstateflashed*conf.flashstrength;}
                    if conf.smokeeffects == 1 {vibs = playerstatesmoked*conf.smokestrength;}

                    if planttime.elapsed >= secondts + 0.4 && dontspam == 0.0 {    //dont run it every update, devices dont handle that well
                        secondts.globaladd(0.4);
                        vibrate((vibk+vibf+vibs)*maincontrol);
                    }                          
                        
                }

            }

            let lastvib = vibk+vibf+vibs;
            //if lastvib == 0.0 {dontspam.globaladd(1.0);} else {dontspam.globalreset();} 
            //second ticker
            if planttime.elapsed >= secondts + 1.0 {secondts.globaladd(1.0);} 

           
        print("execution took :"+now.elapsed);
        }
        else {//stop();
        } //definitely not in a match, spammy
    }
}

