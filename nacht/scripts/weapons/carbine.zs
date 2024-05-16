class Carbine : zmd_Weapon {
    Default {
        Weapon.ammoGive 60;
        Weapon.ammoType 'CarbineAmmo';
        zmd_Weapon.activeAmmo 15;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        mca0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('Raise.Empty');
    Raise:
        mcc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('Zoom.Ready');
        tnt1 a 0 whenNoActiveAmmo('Idle.Empty');
    Idle:
        mcc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Lower.Empty');
    Lower:
        mcc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 whenLastActiveAmmo('Fire.Last');
        mcf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(3, 20, 1);
        mcf0 bcd 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('Reload.Partial');
        mcd0 abcdefghi 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_out");
        mcd0 jklmnopqrstuvwxy 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_futz");
        mcd0 z 3 fr;
        mcd1 abcdef 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_in");
        mcd1 ghijklmnopq 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_charge");
        mcd1 rstuvwxyz 3 fr;
        mcd2 abcd 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('Zoom.In.Empty');
        mcb0 abcdefgh 2;
    Zoom.Ready:
        tnt1 a 0 whenNoActiveAmmo('Zoom.Idle.Empty');
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        mch0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Zoom.Out.Empty');
        mcb0 hgfedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 whenLastActiveAmmo('Zoom.Fire.Last');
        mci0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(0.5, 20, 1);
        mci0 bcd 2 ff;
        goto Ready;
    Fire.Last:
        mcg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(3, 20, 1);
        mcg0 bcd 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        mcj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(0.5, 20, 1);
        mcj0 bcd 2 ff;
        goto Ready;
    Reload.Partial:
        mce0 abcdefghi 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_out");
        mce0 jklmnopqrstuvwxy 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_futz");
        mce0 z 2 fr;
        mce1 abcdef 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_in");
        mce1 ghijklmnopqrstuv 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Raise.Empty:
        mcl0 a 1 a_raise;
        loop;
    Idle.Empty:
        mcl0 a 1 readyWeapon;
        loop;
    Lower.Empty:
        mcl0 a 1 a_lower;
        loop;
    Zoom.In.Empty:
        mck0 abcdefgh 2;
    Zoom.Idle.Empty:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        mcm0 a 1 readyWeapon;
        loop;
    Zoom.Out.Empty:
        mck0 hgfedcba 2;
        goto Ready;
    }
}

class CarbineAmmo : Ammo {
    Default {
        Inventory.maxAmount 120;
    }
}
