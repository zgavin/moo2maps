   short int  type;
   char       count;
   char       current_count;      // damaged if < count
   char       firing_arc;         // 1-F, 2-FX, 4-Bx, 8-B, 16-360
   short int  specials;           // bit vector
   char       ammo;               // valid for missiles only