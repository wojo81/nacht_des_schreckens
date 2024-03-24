class Colt : zmd_Weapon {
    Default {
        Weapon.ammoGive 40;
        Weapon.ammoType 'ColtAmmo';
        zmd_Weapon.clipCapacity 8;
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
        cola a -1;
        loop;
    Select:
        tnt1 a 0 perhapsRaiseEmpty;
    Raise:
        coli a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 perhapsZoomReady;
        tnt1 a 0 perhapsIdleEmpty;
    Idle:
        coli a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsLowerEmpty;
    Lower:
        coli a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 perhapsNoFire;
        tnt1 a 0 perhapsZoomFire;
        tnt1 a 0 perhapsFireLast;
        colf a 2 ff;
        tnt1 a 0 shoot(3, 5);
        tnt1 a 0 a_startSound("weapons/colt");
        colf bc 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 perhapsNoReload;
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsReloadPartial;
        colr ab 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload1");
        colr cdefghijklmnopqrstuv 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload2");
        colr wxyz 3 fr;
        co1r abcdefghij 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        tnt1 a 0 perhapsZoomInEmpty;
        colz abcdef 2;
    Zoom.Ready:
        tnt1 a 0 perhapsZoomIdleEmpty;
    Zoom.Idle:
        tnt1 a 0 perhapsZoomOut;
        colj a 1 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tnt1 a 0 perhapsZoomOutEmpty;
        colz fedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 perhapsZoomFireLast;
        colv a 2 ff;
        tnt1 a 0 shoot(0.25, 5);
        tnt1 a 0 a_startSound("weapons/colt");
        colv bc 2 ff;
        goto Ready;
    Fire.Last:
        coll a 2 ff;
        tnt1 a 0 shoot(3, 5);
        tnt1 a 0 a_startSound("weapons/colt");
        coll bc 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        coly a 2 ff;
        tnt1 a 0 shoot(0.25, 5);
        tnt1 a 0 a_startSound("weapons/colt");
        coly bc 2 ff;
        goto Ready;
    Reload.Partial:
        colp ab 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload1");
        colp cdefghijklmnopqrstuv 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload2");
        colp wxyz 3 fr;
        co1p abcdef 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Raise.Empty:
        colt a 1 a_raise;
        loop;
    Idle.Empty:
        colt a 1 readyWeapon;
        loop;
    Lower.Empty:
        colt a 1 a_lower;
        loop;
    Zoom.In.Empty:
        cols abcdef 2;
    Zoom.Idle.Empty:
        tnt1 a 0 perhapsZoomOut;
        colg a 1 readyWeapon;
        loop;
    Zoom.Out.Empty:
        cols fedcba 2;
        goto Ready;
    }
}

class ColtAmmo : Ammo {
    Default {
        Inventory.maxAmount 72;
    }
}