class DoubleBarrelShotgun : zmd_Weapon {
    Default {
        Weapon.ammoGive 28;
        Weapon.ammoType 'DoubleBarrelShotgunAmmo';
        zmd_Weapon.activeAmmo 2;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        dba0 a -1;
        loop;
    Select:
    Raise:
        dbc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('Zoom.Ready');
    Idle:
        dbc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        dbc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dbf0 a 2 ff;
        tnt1 a 0 shootBullets(5, 15, 4);
        dbf0 bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('Reload.Partial');
        dbd0 abcdefghij 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dbd0 klmnopqrstuvwxyz 3 fr;
        dbd1 abcdefghijklmnopqrstuv 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        dbd1 wxyz 3 fr;
        dbd2 abcd 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        dbb0 abcdefgh 2;
    Zoom.Ready:
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        dbg0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        dbb0 hgfedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dbh0 a 2 ff;
        tnt1 a 0 shootBullets(3, 15, 4);
        dbh0 bcdef 2 ff;
        goto Ready;
    Reload.Partial:
        dbe0 abcdefgh 2 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dbe0 ijklmnopqrstuvwxyz 2 fr;
        dbe1 abcdefghijklmno 2 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        dbe1 pqrstuv 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    }
}

class DoubleBarrelShotgunAmmo : Ammo {
    Default {
        Inventory.maxAmount 60;
    }
}
