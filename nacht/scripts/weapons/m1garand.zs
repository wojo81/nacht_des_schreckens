class M1Garand : zmd_Weapon {
    Default {
        Weapon.ammoGive 64;
        Weapon.ammoType 'M1GarandAmmo';
        zmd_Weapon.clipCapacity 8;
        zmd_Weapon.fastDelay 1;
    }

    States {
    Spawn:
        m1ga a -1;
        loop;
    Select:
        tnt1 a 0 perhapsRaiseEmpty;
    Raise:
        m1gi a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 perhapsZoomReady;
        tnt1 a 0 perhapsIdleEmpty;
    Idle:
        m1gi a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsLowerEmpty;
    Lower:
        m1gi a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 perhapsNoFire;
        tnt1 a 0 perhapsZoomFire;
        tnt1 a 0 perhapsFireLast;
        m1gf a 2 ff;
        tnt1 a 0 shoot(5, 25);
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        m1gf bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 perhapsNoReload;
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsReloadPartial;
        m1gr abcdefghijk 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m1gr lmnop 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m1gr qrstuvwx 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        tnt1 a 0 perhapsZoomInEmpty;
        m1gz abcdef 2;
    Zoom.Ready:
        tnt1 a 0 perhapsZoomIdleEmpty;
    Zoom.Idle:
        tnt1 a 0 perhapsZoomOut;
        m1gj a 1 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsZoomOutEmpty;
        m1gz fedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 perhapsZoomFireLast;
        m1gv a 2 ff;
        tnt1 a 0 shoot(0.25, 25);
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        m1gv bcde 2 ff;
        goto Ready;
    Fire.Last:
        m1gl a 2 ff;
        tnt1 a 0 shoot(5, 25);
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        m1gl bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1gl e 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        m1gy a 2 ff;
        tnt1 a 0 shoot(0.25, 25);
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        m1gy bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1gy ef 2 ff;
        goto Ready;
    Reload.Partial:
        m1gp abcdefghi 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_open");
        m1gp jk 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipout");
        m1gp lmnopqrstuvwxyz 2 fr;
        m11p abcdefg 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m11p hijkl 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m11p mnopqrstuvwxyz 2 fr;
        m12p a 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Raise.Empty:
        m1gt a 1 a_raise;
        loop;
    Idle.Empty:
        m1gt a 1 readyWeapon;
        loop;
    Lower.Empty:
        m1gt a 1 a_lower;
        loop;
    Zoom.In.Empty:
        m1gs abcdef 2;
    Zoom.Idle.Empty:
        tnt1 a 0 perhapsZoomOut;
        m1gg a 1 readyWeapon;
        loop;
    Zoom.Out.Empty:
        m1gs fedcba 2;
        goto Ready;
    }
}

class M1GarandAmmo : Ammo {
    Default {
        Inventory.maxAmount 128;
    }
}