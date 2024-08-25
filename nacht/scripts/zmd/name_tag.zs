class zmd_NameTagger : EventHandler {
    override void RenderOverlay(RenderEvent e) {
        for (let i = 0; i < maxplayers; ++i) {
            if (!playeringame[i] || i == consolePlayer) continue;

            let player = players[i].mo;
            if (!player) continue;

            let pos = player.pos;
            pos.z += player.height + 10;

            let screenPos = worldToScreen(pos);
            if (screenPos.x >= 0) {
                let color = player.findInventory('zmd_LastStand') == null? Font.cr_white: Font.cr_red;
                Screen.DrawText(SmallFont, color,
                                screenPos.x, screenPos.y,
                                players[i].GetUserName(),
                                DTA_VirtualWidth, 480, DTA_VirtualHeight, 360);
            }
        }
    }

    ui Vector2 worldToScreen(Vector3 worldPos) {
        Vector3 eyePos = players[consoleplayer].camera.pos;
        double eyeAngle = players[consoleplayer].camera.angle;

        Vector3 dir = worldPos - eyePos;
        Vector3 dirAngle = (dir.x, dir.y, 0).unit();

        double cosAngle = dirAngle dot (cos(eyeAngle), sin(eyeAngle), 0);
        double sinAngle = dirAngle dot (-sin(eyeAngle), cos(eyeAngle), 0);

        if (cosAngle <= 0) return (-1, -1);

        double x = 200 - atan(sinAngle / cosAngle);
        double y = 120 - atan(dir.z / (dir.xy.length()));

        return (x, y);
    }
}