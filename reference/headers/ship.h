
   struct s_ship_design d;
   char       owner;
   char       status;
   short int  location;
   short int  x;
   short int  y;
   char       group_has_navigator; // does the moving group have navigator?
   char       travelling_speed;    // possibly less than ftl_type
   char       turns_left;          // until arrival 

   char       shield_damage_percent;
   char       drive_damage_percent;
   char       computer_damage;


   char       crew_quality;
   short int  crew_experience;
   short int  officer_index;
   char       special_device_damage_flags[5];  //bit vector Set if Special is damaged
   short int  armor_damage;
   short int  structural_damage;
   char       mission;                  // AI Field
   char       just_built;