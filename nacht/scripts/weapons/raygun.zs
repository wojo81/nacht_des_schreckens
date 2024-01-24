class Raygun : zmd_Weapon {
    Default {
        Weapon.ammoGive 40;
        Weapon.ammoType 'RaygunAmmo';
        zmd_Weapon.clipCapacity 20;
        zmd_Weapon.fastDelay 1;
    }

    States {
    Spawn:
        RAYP a -1;
        loop;
    Select:
    Raise:
        rayi a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 perhapsZoomReady;
    Idle:
        rayi a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        rayi a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 perhapsNoFire;
        tnt1 a 0 perhapsZoomFire;
        rayf a 2 ff;
        tnt1 a 0 shootProjectile('Rayflux');
        rayf bcdefg 2 ff;
        tnt1 a 0 a_refire;
        goto Ready;
    Reload:
        tnt1 a 0 perhapsNoReload;
        tnt1 a 0 zoomOut;
        rayr abcdefghijklmnopqrstuvwxyz 2 fr;
        ra1r abcdefghijklmnopqrstuvwxyz 2 fr;
        ra2r abcdefgh 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        rayz abcde 2;
    Zoom.Ready:
    Zoom.Idle:
        tnt1 a 0 perhapsZoomOut;
        rayj a 1 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        rayz edcba 2;
        goto Ready;
    Zoom.Fire:
        rayv a 2 ff;
        tnt1 a 0 shootProjectile('Rayflux');
        rayv bcde 2 ff;
        tnt1 a 0 a_refire;
        goto Ready;
    }
}

class RaygunAmmo : Ammo {
    Default {
        Inventory.maxAmount 200;
    }
}