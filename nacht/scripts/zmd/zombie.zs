class zmd_Zombie : Actor {
    override int damageMobj(Actor inflictor, Actor source, int damage, Name meansOfDamage, int flags, double angle) {
        let headBottom = self.floorz + self.height - 10;
        let headTop = self.floorz + self.height;

        if (inflictor && meansOfDamage != 'kick' && inflictor.pos.z >= headBottom && inflictor.pos.z <= headTop) {
            meansOfDamage = 'zmd_headshot';
            damage *= 1.5;
        }

        return super.damageMobj(inflictor, source, damage, meansOfDamage, flags, angle);
    }

    Default {
        Obituary "%o died.";
        Health 100 ;
        Radius 12;
        Height 45;
        MaxDropOffHeight 92;
        Mass 200;
        Speed 3;
        DamageType "Melee";

        ActiveSound "zombie/normal";
        PainSound "zombie/inj";
        DeathSound "";

        Monster;

        +FLOORCLIP
        +NOBLOOD
        +NEVERRESPAWN
        +NOINFIGHTING
        +NOEXTREMEDEATH
    }

    States {
    Spawn:
        NAZO A 1 nodelay A_Look;
        NAZO AAAABBBBCCCCDDDD 1 A_Wander;
        Goto See;
    See:
        NAZO AAAA 1 A_Chase;
        NAZO BBBB 1 A_Chase;
        NAZO CCCC 1 A_Chase;
        NAZO DDDD 1 A_Chase;
        Loop;
    CheckSight:
        goto See;
    ZombieRespawn:
        stop;
    Pain:
        NAZI H 0 a_startSound("zombie/shot",1, volume: 0.3);
        // NAZI H 0 A_SpawnItemEx("Gore_Gibbed",random(-2,2),random(-2,2),random(12,14),random(-6,6),random(-6,6),random(6,14),0,SXF_CLIENTSIDE,32);
        // NAZI H 0 A_SpawnItemEx("Gore_",12,random(-2,2),random(12,14),random(0,1),0,0,SXF_CLIENTSIDE);
        NAZI H 0 A_Pain;
        goto See;
    Melee:
        TNT1 A 0 a_startSound("zombie/attack",1, volume: 1.0);
        NAZO E 0 A_FaceTarget;
        NAZO E 0 A_Recoil(-2);
        NAZO EF 6 A_FaceTarget;
        NAZO F 3 A_CustomMeleeAttack(50,"none","none","Melee");
        NAZO A 15;
        goto See;
    Death:
        NAZO I 0 a_startSound("zombie/crack",0);
        NAZO I 1 A_Scream;
        // 	NAZO I 0 A_SpawnItemEx("Gore_Knife",12,random(-2,2),random(12,14),random(0,1),0,0,SXF_CLIENTSIDE);
        // 	TNT1 A 0 A_GiveToTarget("kills",1)
        // 	TNT1 A 0 A_GiveToTarget("killcount",1)
        NAZO IJKLMN 2;
        // 	TNT1 AA 0 A_SpawnItemEx("Gore_Knife",random(1,4),random(-1,1),random(0,6),random(-1,1),random(-1,1),random(1,2),SXF_CLIENTSIDE);
        TNT1 A 0 a_startSound("zombie/fall",0, volume: 0.4);
        NAZO N 1 A_NoBlocking;
        // 	TNT1 A 0 A_SpawnItemEx("RandomPowerup",0,0,0,0,0,0,0,SXF_ABSOLUTEANGLE,242)
        NAZO N 512;
        stop;

    XDeath:
        NAZO I 0 a_startSound("zombie/crack",0);
        NAZO I 1 A_Scream;
      // 	TNT1 A 0 A_GiveToTarget("kills",1);
      // 	TNT1 A 0 A_GiveToTarget("killcount",1)
      // 	TNT1 AAAA 0 A_SpawnItemEx("Gore_Gibbed",random(-1,1),random(-1,1),random(4,16),random(-2,2),random(-2,2),random(-2,2),SXF_CLIENTSIDE)
      //     TNT1 AAAA 0 A_SpawnItemEx("Gore_Knife",random(-1,1),random(-1,1),random(4,16),random(-2,2),random(-2,2),random(-2,2),SXF_CLIENTSIDE)
        NAZO IJKLMN 2;
        TNT1 A 0 a_startSound("zombie/fall",0, volume: 0.4);
        NAZO N 1 A_NoBlocking;
        NAZO N 512;
        stop;
    }
}