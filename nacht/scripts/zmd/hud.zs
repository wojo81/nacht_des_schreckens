// class PointIndicator {
//     int value;
//     vector2 position;
//     vector2 velocity;
//     int ticksLeft;

//     virtual void init(int value, vector2 position) {
//         self.value = value;
//         self.position = position;
//         self.ticksLeft = 70;
//     }

//     void update() {
//         self.position += self.velocity;
//         --self.ticksLeft;
//     }
// }

// class PointIncrease : PointIndicator {
//     override void init(int newValue, vector2 newPosition) {
//         super.init(newValue, newPosition);
//         velocity = (frandom(0.0005, 0.004), frandom(-0.002, 0.002));
//     }
// }

// class PointDecrease : PointIndicator {
//     override void init(int newValue, vector2 newPosition) {
//         super.init(newValue, newPosition);
//         velocity = (0, 0.001);
//     }
// }

// class zmd_Hud : BaseStatusBar {
//     int width, height;
//     int xScale, yScale;

//     zmd_Rounds rounds;

//     Array<PointIndicator> pointIndicators;
//     vector2 indicatorStartPosition;
//     vector2 indicatorSize;

//     void setScale() {
//         self.width = Screen.getWidth();
//         self.height = Screen.getHeight();
//         self.xScale = width / 60;
//         self.yScale = height / 30;

//         self.indicatorStartPosition = (0.13, 0.9);
//     }

//     override void init() {
//         super.init();
//         self.setScale();
//     }

//     override void screenSizeChanged() {
//         self.setScale();
//         self.pointIndicators.clear();
//     }

//     void putText(String text, double x, double y, Font font, int color = Font.cr_untranslated, float scale = 1.0) {
//         Screen.drawText(font, color, x * width, y * height, text, dta_cellx, int(xScale * scale), dta_celly, int(yScale * scale));
//     }

//     void putFadingText(String text, double x, double y, Font font, int color = Font.cr_untranslated, float scale = 1.0, float alpha = 1.0) {
//         Screen.drawText(font, color, x * width, y * height, text,
//             dta_alpha, alpha, dta_cellx, int(xScale * scale), dta_celly, int(yScale * scale));
//     }

//     void centerText(String text, double y, Font font, int color = Font.cr_untranslated, float scale = 1.0) {
//         Screen.drawText(font, color, int((width - xScale * scale * text.codePointCount()) / 2), y * height, text, dta_cellx, int(xScale * scale), dta_celly, int(yScale * scale), dta_spacing, 0);
//     }

//     override void draw(int state, double ticFrac) {
//         super.draw(state, ticFrac);

//         beginHud();

//         let player = zmd_Player(cplayer.mo);
//         if (player == null) {
//             Screen.dim("red", 0.4, 0, 0, Screen.getWidth(), Screen.getHeight());
//             let ammoType1 = getCurrentAmmo();
//             let weapon = zmd_Weapon(cplayer.readyWeapon);
//             if (ammoType1 && weapon) {
//                 if (weapon.clipCapacity > 0) {
//                     putText(weapon.clipSize.."/"..ammoType1.amount, 0.875, 0.9, bigFont, Font.cr_green, 1.25);
//                 } else {
//                     putText(""..ammoType1.amount, 0.875, 0.9, bigFont, Font.cr_green, 1.25);
//                 }
//             }
//             return;
//         }

//         let ammoType1 = getCurrentAmmo();
//         let weapon = zmd_Weapon(cplayer.readyWeapon);
//         if (ammoType1 && weapon) {
//             if (weapon.clipCapacity > 0) {
//                 putText(weapon.clipSize.."/"..ammoType1.amount, 0.875, 0.9, bigFont, Font.cr_green, 1.25);
//             } else {
//                 putText(""..ammoType1.amount, 0.875, 0.9, bigFont, Font.cr_green, 1.25);
//             }
//         }

//         putText(""..cplayer.mo.countInv("zmd_Points"), 0.04, 0.9, bigFont, Font.cr_sapphire, 1.25);

//         if (rounds == null) {
//             rounds = zmd_Rounds(ThinkerIterator.create("zmd_Rounds").next());
//         }

//         if (rounds.isTransitioning) {
//            putFadingText(""..rounds.currentRound, 0.05, 0.05, bigFont, Font.cr_darkGray, 1.25, abs((rounds.tickCount - 17.5) / 35));
//         } else {
//            putText(""..rounds.currentRound, 0.05, 0.05, bigFont, Font.cr_red, 1.25);
//         }

//         let instakillPowerup = zmd_Instakill(player.findInventory("zmd_Instakill"));
//         if (instakillPowerup != null) {
//             let seconds = instakillPowerup.currentTicks / 35;
//             if (seconds > 20) {
//                 let alpha = seconds % 2? 1.0: 0.0;
//                 drawImage("ikic", (-20, 0), flags: di_screen_center_bottom, alpha: alpha);
//             } else {
//                 drawImage("ikic", (-20, 0), flags: di_screen_center_bottom);
//             }
//         }

//         let doublePointsPowerup = zmd_DoublePoints(player.findInventory("zmd_DoublePoints"));
//         if (doublePointsPowerup != null) {
//             let seconds = doublePointsPowerup.currentTicks / 35;
//             if (seconds > 20) {
//                 let alpha = seconds % 2? 1.0: 0.0;
//                 drawImage("dpic", (20, 0), flags: di_screen_center_bottom, alpha: alpha);
//             } else {
//                 drawImage("dpic", (20, 0), flags: di_screen_center_bottom);
//             }
//         }

//         let fireSale = zmd_FireSale(player.findInventory('zmd_FireSale'));
//         if (fireSale != null) {
//             let seconds = fireSale.currentTicks / 35;
//             if (seconds > 20) {
//                 let alpha = seconds % 2? 1.0: 0.0;
//                 drawImage("fsic", (60, 0), flags: di_screen_center_bottom, alpha: alpha);
//             } else {
//                 drawImage("fsic", (60, 0), flags: di_screen_center_bottom);
//             }
//         }

//         if (player.message != "") {
//             centerText(player.message, 0.8, conFont, Font.cr_blue, scale: 1.5);
//         }

//         for (int i = 0; i != pointIndicators.size(); ++i) {
//             let indicator = pointIndicators[i];
//             if (indicator is "PointIncrease")
//                 putFadingText("+"..indicator.value, indicator.position.x, indicator.position.y, bigFont, Font.cr_gold, scale: 0.75,
//                     alpha: min(indicator.ticksLeft / 35.0, 1.0));
//             else
//                 putFadingText(""..-indicator.value, indicator.position.x, indicator.position.y, bigFont, Font.cr_darkRed, scale: 0.75,
//                     alpha: min(indicator.ticksLeft / 35.0, 1.0));
//         }

//         if (player.reviveCountup != 0) {
//             drawImage("revback", (500, 402));
//             drawBar("revfore", "", player.reviveCountup, zmd_DownedPlayer.reviveTime, (500, 400), 0, 0);
//         } else if (player.flashRevive) {
//             drawImage("revback", (500, 402));
//             if (player.flashingTicks >= 5) {
//                 drawImage("revfore", (500, 400));
//             }
//         }
//     }

//     void indicatePointIncrease(int givenPoints) {
//         let indicator = new("PointIncrease");
//         indicator.init(givenPoints, indicatorStartPosition);
//         pointIndicators.push(indicator);
//     }

//     void indicatePointDecrease(int takenPoints) {
//         let indicator = new("PointDecrease");
//         indicator.init(takenPoints, indicatorStartPosition);
//         pointIndicators.push(indicator);
//     }

//     override void tick() {
//         while (pointIndicators.size() && pointIndicators[0].ticksLeft == 0) {
//             pointIndicators.delete(0);
//         }
//         for (int i = 0; i != pointIndicators.size(); ++i) {
//             pointIndicators[i].update();
//         }

//         let player = zmd_Player(cplayer.mo);
//         if (player && player.usedPointDeltas) {
//             for (int i = 0; i != player.pointDeltas.size(); ++i) {
//                 if (player.pointDeltas[i] > 0)
//                     indicatePointIncrease(player.pointDeltas[i]);
//                 else
//                     indicatePointDecrease(player.pointDeltas[i]);
//             }
//         }
//     }
// }

class zmd_HudElement {
    virtual ui void draw(zmd_Hud hud, int state, double tickFrac) {}
    virtual ui void tick() {}
}

class zmd_Hud : BaseStatusBar {
    const margin = 7;
    const bottom_margin = -margin - 12;
    const right_margin = -margin - 3;

    Array<zmd_HudElement> elements;
    HudFont defaultFont;
    HudFont hintFont;

    override void init() {
        self.defaultFont = HudFont.create(bigfont);
        self.hintFont = HudFont.create(confont);
    }

    override void tick() {
        let player = zmd_Player(self.cplayer.mo);
        if (player)
            foreach (element : player.hudElements)
               element.tick();
    }

    override void draw(int state, double ticFrac) {
        super.draw(state, ticFrac);
        self.beginHud();
        let player = zmd_Player(self.cplayer.mo);
        if (player)
            foreach (element : player.hudElements)
                element.draw(self, state, ticFrac);
    }
}