   char  picture;
   char  name[20];
   char  race_name[15];
   char  eliminated;
   char  race;
   char  color;
   char  personality;
   char  objectives;            
   short int home_planet_id;

   short int network_player_id;         //bookeeping
   char  player_done_flags;             //bookeeping

   unsigned short int  dead_field;
   char  research_breakthrough;         // did they complete a field this turn?

   char  tax_rate;                      // taxes are 0,10,20,30,40,50% of industry production
   int   bc;                            // our current amount of cash

   short int  n_freighters;
   short int  surplus_freighters;       //bookeeping

   short int command_points;
   short int command_points_used;

   // sum of following 3 should be <= n_freighters * FREIGHTER_CAPACITY
   short int  food_freighted;
   short int  settlers_freighted;       // # settlers enroute, stored in settlers array:

//        struct Settler_Info {
//              unsigned source_colony:8; // colony id or MAX_COLONIES if already in space (cannot be redirected)
//              unsigned dest_planet:8;   // planet id
//              unsigned player:4;        // player id or POP_ANDROID or POP_NATIVE
//              unsigned eta:4;           // if settler, takes this many turns to arrive
//              unsigned job:2;
//        };


   struct Settler_Info settlers[25]; // slots < settlers_freighted are current settlers

   short int  total_pop;                  // of all our colonies

   // total amounts produced by all colonies this turn:
   short int  food_produced;
   short int  industry_produced;
   short int  research_produced;
   short int  bc_produced;

   // following are >0 if we had extra, <0 if we were short, this turn:
   short int  surplus_food; // only accounting for unblockaded colonies
   short int  surplus_bc;

   // maintenance bc costs:
   int total_maintenance;
   short int maintenance[n_maintenance_classes]; // sum == total_maintenance

   char  tech_fields[MAX_TECH_FIELDS];              // 0-UNRESEARCHABLE, 1-NOT_KNOWN, 2-ON_RESEARCH_LIST, 3-KNOWN            
   char  tech_applications[MAX_TECH_APPLICATIONS];  // 0-UNRESEARCHABLE, 1-NOT_KNOWN, 2-ON_RESEARCH_LIST, 3-KNOWN  

   int   research_accumulated;
   char  captured_orion;
   char  captured_antares;
   char  won_council_vote;
   int   player_defeated[MAX_PLAYERS]; //stardate or 0
   unsigned short int captured_population;
   char  last_attacker;

   char  ship_design_theme;      //AI FIELDS
   char  ship_special_theme;     //AI FIELDS
   char  tech_apps_learned[4];   //bookeeping
   char  tech_modifiers[17];     //not in use

   char hyper_advanced_tech[8];  // LEVEL of hyper advanced tech achieved.

   int total_known_tech_cost;    // for history display

   char knows_racial_stats;      //not used

   int last_tech_report_date[MAX_PLAYERS];  //not used

   // bitfields, tell whether given player knows the app:
   uchar player_tech_applications[MAX_PLAYERS][(MAX_TECH_APPLICATIONS + 7) / 8];


   char  current_research_field;        // should be > 0, indicating which field
   char  current_research_application;  // 
   char  got_new_app;                   // within the last turn; causes AI to redecide field to research

   int   ship_range;

   struct s_ship_design  ship_designs[6];
   short int  ships_built[6];

   char  contact[MAX_PLAYERS];
   char just_established_contact;       // bitvector by player index
   char n_times_established_contact[MAX_PLAYERS];
   char  within_range[MAX_PLAYERS];     // tells if this player can reach that player
                                        // (contact is symmetric, within_range is not)

   char do_not_research;        // should the AI quit researching from now on?

   schar offensive_stagepoint;  //AI FIELD

   uchar best_ftl_drive;
   uchar ship_speed;

   char officer_for_hire;       // -1 or id of available officer this turn

   short int n_trade_pops;
   short int current_trade_agreement_level[MAX_PLAYERS];
   short int trade_agreement_goal[MAX_PLAYERS];

   short int n_research_pops;
   short int current_research_agreement_level[MAX_PLAYERS];
   short int research_agreement_goal[MAX_PLAYERS];

   char fighter_beam_type; 
   char fighter_bomb_type; 


   short int  total_research;                           //AI Field
   short int  total_ships;                              //AI Field
   unsigned long int total_ship_strength[MAX_PLAYERS];  //AI Field
   short int  total_colonies;                           //AI Field
   char  failed_to_expand;                              //AI Field


//ÍÍÍÍÍÍÍdiplomacy stuff ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
   char  first_contact[MAX_PLAYERS];
   char  relations[MAX_PLAYERS];
   char  base_relations[MAX_PLAYERS];

   char  treaty[MAX_PLAYERS];  
   char  trade_treaty[MAX_PLAYERS];
   char  research_treaty[MAX_PLAYERS];
   short int  tribute_treaty[MAX_PLAYERS];

   char  diplomacy_incident[MAX_PLAYERS];
   char  diplomacy_message[MAX_PLAYERS];
   short int  diplomacy_severity[MAX_PLAYERS];
   short int  diplomacy_value[MAX_PLAYERS];
   short int  diplomacy_system[MAX_PLAYERS];

   short int  treaty_modifier[MAX_PLAYERS];
   short int  trade_modifier[MAX_PLAYERS];
   short int  tech_exchange_modifier[MAX_PLAYERS];
   short int  peace_modifier[MAX_PLAYERS];

   char  last_bad_diplomatic_incident[MAX_PLAYERS];
   char  broken_treaties_modifier[MAX_PLAYERS];
   char  last_broken_treaty[MAX_PLAYERS];
   char  last_gift[MAX_PLAYERS];

   short int  ship_war_losses[MAX_PLAYERS];          // 1) small, 2) medium, 3) large, etc.
   short int  colony_war_losses[MAX_PLAYERS];        // 1/killed or captured colonist + 10/captured or destroyed colony
   char  biological_weapons_flag[MAX_PLAYERS];       // T/F killed a colonist on one of your colonies
   char  time_since_last_attack[MAX_PLAYERS];        // when I attack X, set [X] to 0

   char  threats[MAX_PLAYERS];
   char  dishonored_flag[MAX_PLAYERS];
   char  peace_duration[MAX_PLAYERS];
   short int  last_turn_diplomacy_severity[MAX_PLAYERS];
   char  last_broken_treaty_type[MAX_PLAYERS];

   char  last_turn_treaty[MAX_PLAYERS];

   char  diplomacy_proposal_request[MAX_PLAYERS];          // 0) none, 1) First Offer, 2) Second Offer, 3) First Offer, Better 2nd Offer
   char  diplomacy_proposal_tribute_bribe[MAX_PLAYERS];    // 0) none, 1) 5%/year,     2) 10%/year      10% tribute for better offer
   char  diplomacy_proposal_tech_bribe1[MAX_PLAYERS];      //
   char  diplomacy_proposal_tech_bribe2[MAX_PLAYERS];      // better offer technology or
   short int  diplomacy_proposal_gold_bribe[MAX_PLAYERS];       // +50% for better offer
   char  diplomacy_proposal_war_player[MAX_PLAYERS];
   int   diplomacy_proposal_exchange_max_value[MAX_PLAYERS]; // tech exchange max value
   char  diplomacy_proposal_exchange_tech[MAX_PLAYERS];      // tech exchange max value
   short int  diplomacy_proposal_system_bribe[MAX_PLAYERS];   

   short int  sneak_attack_planet;
   char  sneak_attack_message;
   char  sneak_attack_player; // planet's ownership could have changed before we arrive

   char  council_threat;
   short int  reward_amount[MAX_PLAYERS];
   char  reward_tech[MAX_PLAYERS];
   char  reward_attack_player[MAX_PLAYERS];


   short int  food_shortage_duration;

   char  trust_worthiness[MAX_PLAYERS];
   char  trust_breaker_player[MAX_PLAYERS];
   char  trust_breaker_treaty[MAX_PLAYERS];

   char  stop_spying_duration[MAX_PLAYERS];
   char  stop_blockading_duration[MAX_PLAYERS];
   char  war_buildup_duration; // nonzero means prepare for starting war in future

   short int  last_diplomacy_proposal_turn[MAX_PLAYERS];
   short int  diplomacy_proposal_rejection[MAX_PLAYERS];

   short int  opportunity_planet_num[MAX_PLAYERS];
   short int  opportunity_planet_value[MAX_PLAYERS];
   int  opportunity_actual_attacker_ratio[MAX_PLAYERS];

      
   //these are padding...
   short int  temp_diplomacy_dummy1[MAX_PLAYERS];

   char  diplomacy_demand_rejection_message[MAX_PLAYERS];

   char  last_diplomacy_threat_turn[MAX_PLAYERS];

   schar delayed_diplomacy_orders[MAX_PLAYERS]; // 10/9 by Russ
         // can be NONE, or DELAYED_DECLARE_WAR, DELAYED_MAKE_PEACE, DELAYED_BREAK_ALLIANCE

//ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
   char current_government;
   char pop_growth_bonus;
   char food_bonus;
   char production_bonus;
   char research_bonus;
   char tax_bonus;
   char ship_defense;
   char ship_attack;
   char ground_combat_bonus;
   char spying_bonus;

   char  low_g_world;
   char  heavy_g_world;
   char  aquatic;
   char  subterranean;
   char  large_home_world;
   char  rich_home_world;
   char  ancient_home_world;
   char  cybernetic;
   char  eats_minerals;
   char  repulsive;
   char  charismatic;
   char  uncreative;
   char  creative;
   char  environment_immune;
   char  fantastic_traders;
   char  telepathic;
   char  lucky;
   char  omniscience;
   char  stealthy_ships;
   char  trans_dimensional;
   char  warlord;

   // when they get evolution tech, players will interact with race screen
   // during start-o-turn reports, then during the next turn calc the
   // selected changes will be applied:  Meanwhile, they are briefly stored here:
   char   evolutionary_upgrade[31];
   char   picked_evolutionary_upgrade;  // false until they get evolution tech and pick new racial stats
   char   applied_evolutionary_upgrade; // false until they get evolution tech and new racial stats are actually applied

// Elemental history arrays:
   unsigned char  fleet_history[350];
   unsigned char  tech_history[350];
   unsigned char  population_history[350];
   unsigned char  production_history[350];

   uchar  spies[MAX_PLAYERS]; 
   char  history_btns;         //1-bit flags for history graph buttons
   char  ignoring;             //Set a bit to ignore a player

   char  peace_flags[MAX_PLAYERS];
   uchar cheated;                       //bitfield
   uint  stardate_last_offered_hero;
   char  current_zoom_level;            //
   sint  cur_map_x;                     // for hotseat games to restore mainscrn map
   sint  cur_map_y;                     //
   char council_voted_for;
   schar surrender_to;                  // normally -1, else a player id
   short int time_since_last_lucky_event;
   char  has_galactic_lore;
   uchar warned_about_cheating_player;  //BITFIELD based on player num
   uchar cheated_this_turn;             //0 == didn;t cheat this turn
   int tribute_income;
   char filler[45];                     // not used