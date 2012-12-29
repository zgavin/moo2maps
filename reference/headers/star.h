   char  name[15];
   short int  x;                                        // x coordinate of star
   short int  y;                                        // y coordinate of star
   char  size;                                          //display type (0,1, or 2)
   char  owner;
   char  pict_type;                                     
   char  spectral_class;                                // star color
   char  last_planet_selected[MAX_PLAYERS];             // bookeeping
   char  black_hole_blocks[(MAX_STARS + 7) / 8];        // precomputed bitfield if bit is set there is a black hole between the stars.
   char  system_special;                                // NO_SPECIAL is valid
   char  wormhole_star_id;                              //NONE is valid
   char  blockaded;     // bitvector tells whether each player is blockaded
                        // e.g. TEST_BIT(blockaded, i) tells whether i is blockaded by anyone
                        // this is NOT superseded by blockaded_by because nonplayer monsters & antarans can also blockade a player
   char blockaded_by[MAX_PLAYERS]; // indexed by player, bitvector tells whether given player blockades index player
                                   // e.g. TEST_BIT(blockaded_by[i], j) tells whether i is blockaded by j
                                   // this is for diplomacy so AI can tell which players are blockading them at a star
   char visited;                   // bitvector tells whether each player has ever visited
   char just_visited;              // bitvector tells whether each player 1st visited on prev turn & should get report
   char ignore_colony_ships; // bitvector tells if each player requested ignore colony ships
                             // reset each time a new colony ship enters star
   char ignore_combat_ships; // bitvector tells if each player requested ignore combat ships
                             // (the much requested "don't make me hit Only Blockade" feature)
                             // reset each time a new combat ship enters star
   char colonize_player;     // 0..7 or -1 
   char has_colony;          // bitvector tells whether each player has a colony
   char has_warp_field_interdictor; // bitvector tells whether each player has a wfi in system
   char next_wfi_in_list;           // bookeeping
   char has_tachyon;                // bitvector tells whether each player has a tachyon
   char has_subspace;               // bitvector tells whether each player has a subspace
   char has_stargate;               // bitvector tells whether each player has a stargate
   char has_jumpgate;               // bitvector tells whether each player has a jumpgate
   char has_artemis_net;            // bitvector
   char is_stagepoint;              // bitvector tells whether star is stagepoint for each AI
   char has_dimensional_portal;     // bitvector

   
   char officer_index[MAX_PLAYERS]; //officers are now at stars and not colonies
   unsigned short int planet_index[5];
   unsigned short int relocate_ship_to[MAX_PLAYERS]; //star index all ships will be relocated TO
   char not_used[3];                   //
   char surrender_to[MAX_PLAYERS];    // normally -1, else player to give colonies to
   char in_nebula;                    // is this star in a nebula?
   char artifacts_gave_app;           // has the ancient artifacts app been given out yet?
   