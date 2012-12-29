
int     version;
char    description[37]; //- save game description
int     game_type;       //- 0:Single Player, 1:Hotseat, 2:Network, 3:Modem

char  end_of_turn_summary;
char  end_of_turn_wait;
char  random_events;
char  enemy_moves;
char  expanding_help;
char  auto_select_ships;
char  animations_on;
char  auto_select_colony;
char  show_relocation_lines;
char  show_gnn_report;
char  auto_delete_tg_housing;
char  auto_saves;

char  only_show_serious_turn_summary_reports;

char  ship_initiative;
char  option_14;
char  option_15;
char  option_16;

char sound_fx_on;
char sound_fx_level;
char music_on;
char music_level;
signed char active_save_slot;
unsigned char  multi_player_game_type;

char net_game_name[9]; //char net_game_name[NET_GAME_NAME_LENGTH + 1]; //9 bytes
char s_modem_comm_modem_settings[131]; //struct s_modem_comm modem_settings;           //131 bytes
char s_modem_init_string_modem_init_string[11]; //struct s_modem_init_string modem_init_string; //11 bytes

char  combat_speed_flag;
char  combat_legal_moves_flag;
char  combat_msl_impact_flag;
char  combat_shield_arcs_flag;
char  combat_grid_flag;

char filler1[25];
unsigned char language;
char xenons_exist_flag;
char game_difficulty;
char number_of_players;
char galaxy_size;
char galaxy_age;
char strategic_combat_flag;
char starting_civilization_level;
unsigned long start_of_game_seed;

short int  sound_toggle;
short int  mouse_driver;

short int  release_version;

char        dummy[10][20];
short int   dummy2[10];
short int   dummy3[10];
char        dummy4[10];
unsigned char       filler2[75];

unsigned long  random_seed;

short int current_colony_count;

struct s_colony colonies[250];
struct s_planet planets[360];
struct s_star stars[72];
struct s_leader leaders[67];
struct s_player players[8];
struct s_ship ships[500];

char dummy5[3316];

short int  council_flag;
short int  next_council_meeting_turn;

short int  not_used[5];
 
// Antarens
 
sint invasion_chance;                          

sint off_resource_level;                       //resources used to buy new ships
sint def_resource_level;                       //2-Sml, 5-Med, 12-Lrg, 30-Huge, 75-Titan

sint n_def_ships[9];                           //Ship counts by size
sint n_off_ships[9];                           //0-Sml, 1-Med, 2-Lrg, 3-Huge, 4-Titan, 5-8 not used
sint n_off_ships_deployed[9];

bool conquered;                                 //set to TRUE when antarans are dead
int last_invasion_date;                         //stardate
uchar displayed_report;                         //bookeeping

