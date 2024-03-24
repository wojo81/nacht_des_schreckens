class DoubleBarrelShotgun : zmd_Weapon {
    Default {
        Weapon.ammoGive 30;
        Weapon.ammoType 'DoubleBarrelShotgunAmmo';
        zmd_Weapon.clipCapacity 2;
        zmd_Weapon.reloadRate 3;
        zmd_Weapon.fireRate 2;
    }

    override void activateFastReload() {
        self.reloadRate = 2;
    }

    override void activateDoubleFire() {
        self.fireRate = 1;
    }

    States {
    Spawn:
        dbla a -1;
        loop;
    Select:
    Raise:
        dbli a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 perhapsZoomReady;
    Idle:
        dbli a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        dbli a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 perhapsNoFire;
        tnt1 a 0 perhapsZoomFire;
        dblf a 2 ff;
        tnt1 a 0 shoot(5, 15, 4);
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dblf bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 perhapsNoReload;
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsReloadPartialOnly;
        dblr abcdefghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dblr lmnopqrstuvwxyz 3 fr;
        db1r abcdefghijklmnopqrstuvw 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        db1r xyz 3 fr;
        db2r abcd 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        dblz abcdefgh 2;
    Zoom.Ready:
    Zoom.Idle:
        tnt1 a 0 perhapsZoomOut;
        dblj a 1 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        dblz hgfedcba 2;
        goto Ready;
    Zoom.Fire:
        dblv a 2 ff;
        tnt1 a 0 shoot(3, 15, 4);
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dblv bcdef 2 ff;
        goto Ready;
    Reload.Partial:
        dblp abcdefghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dblp lmnopqrstuvwxyz 3 fr;
        db1p abcdefghijklmnop 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        db1p qrstuv 3 fr;
        tnt1 a 0 reloadPartially;
        goto Ready;
    }
}

class DoubleBarrelShotgunAmmo : Ammo {
    Default {
        Inventory.maxAmount 60;
    }
}