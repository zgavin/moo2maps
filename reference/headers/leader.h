        char            name[15];
        char            title[20];
        char            type;           //0-ship 1-colony
        short int       xp;
        unsigned int    general_skills; //bitvector for general skills
        unsigned int    special_skills; //bitvector includes either ship || colony skills
        unsigned char   tech_application[3];    // Application id's of inherent techs
        char            pict_num;

        short int  skill_value;             //  
        char       level;                   //
        short int  location;                //
        char       eta;                     //
        char       display_level_popup;     //if TRUE, draw officer-made-level popup
        char       status;                  //
        char       player_index;            //