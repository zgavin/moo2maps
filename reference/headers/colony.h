
char       owner;                         // 0..NUM_PLAYERS or -1
char       allocated_to;                  // bookeeping
short int  planet;                        // planet id
short int  officer;                       // not used

char  outpost_flag;                   // TRUE if an outpost

char  morale;                       // morale bonus +/-
short int  pollution;                     // production lost to pollution

char  n_pops;                       // total population
char  specialty;                    // Colony specialty used in display only

//   struct Pop_Info {
//           unsigned player:4;           // player id or POP_ANDROID or POP_NATIVE
//           unsigned loyalty:3;          // player id
//           unsigned job:2;              // 0-farmer, 1-worker, 2-scientist
//           unsigned employed:1;
//           unsigned conquered:1;        // true iff loyalty != colony owner
//   };

struct Pop_Info pop[MAX_POPS];       //

short int   pop_roundoff[N_POP_PLAYERS];  // K toward next pop unit for each race
short int   pop_growth[N_POP_PLAYERS];    // each race grows independently

char  n_turns_existed;               // bookeeping
char  food2_per_farmer;              // Food per farmer in half-units of food
char  industry_per_worker;
unsigned char  research_per_scientist;
char  max_farms;                     //
char  max_population;
char  climate;

short int   ground_strength;         // calculated for ai
short int   space_strength;          // calculated for ai

short int   total_production[3];     // gross amount produced  0-food, 1-industry, 2-research
char  maintenance[3];                // how much is spent feeding people/androids 0-food, 1-industry, 2-research

short int   imports[3];              // + means importing, - means surplus
                                     // (surplus exported only if unblockaded)

char n_industry_recyclers;           // for recycling pollution reduction

// for parcelling out food/metal in priority ordering:
// counted in half units due to cybernetic woes.
char food2_needed_for_our_empire;                   //-------------------------------
char food2_needed_for_assimilated;                  //
char food2_needed_for_conquered;                    //
char food2_needed_for_natives;                      //these are all bookeeping entries
char industry2_needed_for_our_empire;               //
char industry2_needed_for_androids;                 //
char industry2_needed_for_assimilated;              //
char industry2_needed_for_conquered;                //
char food2_needed_for_empire[MAX_PLAYERS];          //
char industry2_needed_for_empire[MAX_PLAYERS];      //
char n_food_replicated;                             //

char padding[5];
short int  producing[7];                            // building queue
short int  just_produced;                           // if not -1, then colony completed this product last turn
short int  production_spent;
short int  n_industry_taxed;
char       auto_building;
short int  production_surplus;                      // for when production is changed
short int  bought_outright;                         // amount of production bought
                                                    //---------------------------

char occupation_points;                             // 240 points to assimilate 1 pop.
char occupation_policy;                             // 0-genocide , 3-normal

// military
short int military[2];                              // 0-infantry, 1-tanks
char tank_roundoff;
char infantry_roundoff;

char buildings[MAX_BUILDINGS];
unsigned short int last_turn_building_destroyed;