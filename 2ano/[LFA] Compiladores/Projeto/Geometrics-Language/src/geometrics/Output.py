#!/usr/bin/python3
import pygame as py
import pygame
import random
import math

pygame.font.init()

fps = 100 
clock = py.time.Clock()
run = True
drawstringlllll_ = False

WHITE_ = (255,255,255)
BLACK_ = (0,0,0)
BLUE_ = (0,0,255)
YELLOW_ = (255,255,0)
RED_ = (255,0,0) 
GREEN_ = (0,255,0)
GRAY_ = (155,155,155)
ORANGE_ = (255,128,0)
PURPLE_ = (128,0,128)


class Circle:
    def __init__(self,x,y,r):
        self.r = r
        self.x = x
        self.y = y
        self.hidden = False
        self.thickness = 1
        self.filled = False
        self.color = WHITE_

    def translate(self,x,y):
        self.x = self.x + x
        self.y = self.y  + y

    def rotate(self, angle, xc, yc):
        angle = math.radians(angle)
        cos = math.cos(angle)
        sin = math.sin(angle)
        temp =  (self.x-xc)*cos - (self.y-yc)*sin + xc
        self.y = (self.x-xc)*sin + (self.y-yc)*cos + yc
        self.x = temp

    def collideEdge(self, sizex, sizey):
        p1 = self.x+self.r
        p2 = self.y+self.r
        p3 = self.x-self.r
        p4 = self.y-self.r
        if(p1 >= sizex or p2 >= sizey or p3 <= 0 or p4 <= 0):
            return True
        else:
            return False

    def getRect(self):
        if (self.hidden == False):
            return pygame.Rect(self.x - self.r + 0.25*self.r, self.y - self.r + self.r*0.25, self.r*2 - self.r*0.25, self.r*2 - self.r*0.25)

    def update(self):
        self.x = self.x
        self.y = self.y
        self.r = self.r

class Line:
    def __init__(self, x1,y1,x2,y2):
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.color = WHITE_
        self.hidden = False
        self.thickness = 1
        self.distance = math.floor(math.dist([self.x1, self.y1], [self.x2, self.y2]))

    def translate(self, x, y):
        self.x1 = self.x1 + x
        self.x2 = self.x2 + x
        self.y1 = self.y1 + y
        self.y2 = self.y2 + y

    def rotate(self, angle, xc, yc):
        angle = math.radians(angle)
        cos = math.cos(angle)
        sin = math.sin(angle)
        temp =  (self.x2-xc)*cos - (self.y2-yc)*sin + xc
        self.y2 = (self.x2-xc)*sin + (self.y2-yc)*cos + yc
        self.x2 = temp
        temp =  (self.x1-xc)*cos - (self.y1-yc)*sin + xc
        self.y1 = (self.x1-xc)*sin + (self.y1-yc)*cos + yc
        self.x1 = temp

    def collideEdge(self, sizex, sizey):
        if(self.x1 >= sizex or self.x1 <= 0 or self.x2 >= sizex or self.x2 <= 0 or self.y1 >= sizey or self.y1 <= 0 or self.y2 >= sizey or self.y2 <= 0):
            return True
        else:
            return False

class Square:
    def __init__(self, x, y, w, h):
        self.x1 = x
        self.y1 = y
        self.x2 = x+w
        self.y2 = y
        self.x3 = x+w
        self.y3 = y+h
        self.x4 = x
        self.y4 = y+h
        self.w = w
        self.h = h
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3),(self.x4,self.y4))
        self.color = WHITE_
        self.hidden = False
        self.filled = False
        self.thickness = 1

    def translate(self, x,y):
        self.x1 = self.x1 + x
        self.y1 = self.y1 + y
        self.x2 = self.x2 + x
        self.y2 = self.y2 + y
        self.x3 = self.x3 + x
        self.y3 = self.y3 + y
        self.x4 = self.x4 + x
        self.y4 = self.y4 + y
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3),(self.x4,self.y4))

    def rotate(self, angle, xc, yc):
        angle = math.radians(angle)
        cos = math.cos(angle)
        sin = math.sin(angle)
        temp =  (self.x2-xc)*cos - (self.y2-yc)*sin + xc
        self.y2 = (self.x2-xc)*sin + (self.y2-yc)*cos + yc
        self.x2 = temp
        temp =  (self.x1-xc)*cos - (self.y1-yc)*sin + xc
        self.y1 = (self.x1-xc)*sin + (self.y1-yc)*cos + yc
        self.x1 = temp
        temp =  (self.x3-xc)*cos - (self.y3-yc)*sin + xc
        self.y3 = (self.x3-xc)*sin + (self.y3-yc)*cos + yc
        self.x3 = temp
        temp =  (self.x4-xc)*cos - (self.y4-yc)*sin + xc
        self.y4 = (self.x4-xc)*sin + (self.y4-yc)*cos + yc
        self.x4 = temp
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3),(self.x4,self.y4))

    def update(self):
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3),(self.x4,self.y4))

    def collideEdge(self, sizex, sizey):
        if(self.x1 >= sizex or self.x1 <= 0 or self.x2 >= sizex or self.x2 <= 0 or self.x3 >= sizex or self.x3 <= 0 or self.x4 >= sizex or self.x4 <= 0 or self.y1 >= sizey or self.y1 <= 0 or self.y2 >= sizey or self.y2 <= 0 or self.y3 >= sizey or self.y3 <= 0 or self.y4 >= sizey or self.y4 <= 0):
            return True
        else:
            return False

    def getRect(self):
        if (self.hidden == False):
            return pygame.Rect(self.x1, self.y1, self.w, self.h)

class Triangle:
    def __init__(self, x, y, x2, y2, x3, y3):
            self.x1 = x3
            self.y1 = y3
            self.x2 = x
            self.y2 = y
            self.x3 = x2
            self.y3 = y2
            self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3))
            self.hidden = False
            self.thickness = 1
            self.filled = False
            self.color = WHITE_

    def translate(self, x,y):
        self.x1 = self.x1 + x
        self.y1 = self.y1 + y
        self.x2 = self.x2 + x
        self.y2 = self.y2 + y
        self.x3 = self.x3 + x
        self.y3 = self.y3 + y
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3))

    def rotate(self, angle, xc, yc):
        angle = math.radians(angle)
        cos = math.cos(angle)
        sin = math.sin(angle)
        temp =  (self.x2-xc)*cos - (self.y2-yc)*sin + xc
        self.y2 = (self.x2-xc)*sin + (self.y2-yc)*cos + yc
        self.x2 = temp
        temp =  (self.x1-xc)*cos - (self.y1-yc)*sin + xc
        self.y1 = (self.x1-xc)*sin + (self.y1-yc)*cos + yc
        self.x1 = temp
        temp =  (self.x3-xc)*cos - (self.y3-yc)*sin + xc
        self.y3 = (self.x3-xc)*sin + (self.y3-yc)*cos + yc
        self.x3 = temp
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3))

    def update(self):
        self.points = ((self.x1,self.y1),(self.x2,self.y2),(self.x3,self.y3))

    def collideEdge(self, sizex, sizey):
        if(self.x1 >= sizex or self.x1 <= 0 or self.x2 >= sizex or self.x2 <= 0 or self.x3 >= sizex or self.x3 <= 0 or self.y1 >= sizey or self.y1 <= 0 or self.y2 >= sizey or self.y2 <= 0 or self.y3 >= sizey or self.y3 <= 0):
            return True
        else:
            return False

    def getRect(self):
        if (self.hidden == False):
            return pygame.draw.polygon(display, self.color, self.points, self.thickness)


def figureCollision(a, b):
    try:
        return a.colliderect(b)
    except:
        return False

internal_timer = 0

WIDTH  = 1200
HEIGHT = 800
display = pygame.display.set_mode([WIDTH,HEIGHT])
pygame.display.set_caption('BrickBreaker')

left_ = Square(5,0, 1, 800)
left_.color = BLACK_
top_ = Square(1,7, 1200, 1)
top_.color = BLACK_
right_ = Square(1195,0, 1, 800)
right_.color = BLACK_
evil21_ = Square(1010,140, 140, 5)
evil21_.thickness = 0
evil20_ = Square(850,140, 140, 5)
evil20_.thickness = 0
plataforma_ = Square(480,780, 240, 8)
plataforma_.thickness = 0
evil7_ = Square(1010,20, 140, 5)
evil7_.thickness = 0
evil6_ = Square(850,20, 140, 5)
evil6_.thickness = 0
evil19_ = Square(690,140, 140, 5)
evil19_.thickness = 0
evil5_ = Square(690,20, 140, 5)
evil5_.thickness = 0
evil4_ = Square(530,20, 140, 5)
evil4_.thickness = 0
evil3_ = Square(370,20, 140, 5)
evil3_.thickness = 0
ball_ = Circle(280,280,25)
ball_.color = GRAY_
ball_.thickness = 0
evil2_ = Square(210,20, 140, 5)
evil2_.thickness = 0
evil1_ = Square(50,20, 140, 5)
evil1_.thickness = 0
evil12_ = Square(690,80, 140, 5)
evil12_.thickness = 0
evil11_ = Square(530,80, 140, 5)
evil11_.thickness = 0
evil14_ = Square(1010,80, 140, 5)
evil14_.thickness = 0
evil13_ = Square(850,80, 140, 5)
evil13_.thickness = 0
evil16_ = Square(210,140, 140, 5)
evil16_.thickness = 0
evil15_ = Square(50,140, 140, 5)
evil15_.thickness = 0
evil9_ = Square(210,80, 140, 5)
evil9_.thickness = 0
evil18_ = Square(530,140, 140, 5)
evil18_.thickness = 0
evil8_ = Square(50,80, 140, 5)
evil8_.thickness = 0
evil17_ = Square(370,140, 140, 5)
evil17_.thickness = 0
evil10_ = Square(370,80, 140, 5)
evil10_.thickness = 0
bottom_ = Square(1,795, 1200, 1)
bottom_.color = BLACK_
v1 = 255
v2 = 100
v3 = 0
cor_player_ = (v1,v2,v3)
v4 = cor_player_
plataforma_.color = v4

v5 = True
evil1_.thickness = 0
v6 = True
evil2_.thickness = 0
v7 = True
evil3_.thickness = 0
v8 = True
evil4_.thickness = 0
v9 = True
evil5_.thickness = 0
v10 = True
evil6_.thickness = 0
v11 = True
evil7_.thickness = 0
v12 = True
evil8_.thickness = 0
v13 = True
evil9_.thickness = 0
v14 = True
evil10_.thickness = 0
v15 = True
evil11_.thickness = 0
v16 = True
evil12_.thickness = 0
v17 = True
evil13_.thickness = 0
v18 = True
evil14_.thickness = 0
v19 = True
evil15_.thickness = 0
v20 = True
evil16_.thickness = 0
v21 = True
evil17_.thickness = 0
v22 = True
evil18_.thickness = 0
v23 = True
evil19_.thickness = 0
v24 = True
evil20_.thickness = 0
v25 = True
evil21_.thickness = 0
v26 = BLACK_
top_.color = v26
v27 = BLACK_
bottom_.color = v27
v28 = BLACK_
right_.color = v28
v29 = BLACK_
left_.color = v29

v30 = 4
speedx_ = v30
v31 = 4
speedy_ = v31
v32 = 4
playerSpeed_ = v32
v33 = False
terminou_ = v33
v34 = 21
toques_ = v34
while(run):
        clock.tick(fps)  

        eventos = pygame.event.get()
        try:
            if(eventos[0].type == 32787):
                run = False
        except:
            pass
        display.fill(BLACK_)

        if(drawstringlllll_== True):
            display.blit(text, textRect)

        ball_.update()
        bottom_.update()
        v35 = figureCollision(ball_.getRect(),bottom_.getRect())
        tocaBase_ = v35
        ball_.update()
        right_.update()
        v36 = figureCollision(ball_.getRect(),right_.getRect())
        tocaDireita_ = v36
        ball_.update()
        left_.update()
        v37 = figureCollision(ball_.getRect(),left_.getRect())
        tocaEsquerda_ = v37
        ball_.update()
        top_.update()
        v38 = figureCollision(ball_.getRect(),top_.getRect())
        tocaTopo_ = v38
        ball_.update()
        plataforma_.update()
        v39 = figureCollision(ball_.getRect(),plataforma_.getRect())
        tocaPlat_ = v39
        v40 = playerSpeed_
        v41 = 0
        plataforma_.translate(v40, v41)
        ball_.update()
        evil14_.update()
        v42 = figureCollision(ball_.getRect(),evil14_.getRect())
        toca14_ = v42
        ball_.update()
        evil15_.update()
        v43 = figureCollision(ball_.getRect(),evil15_.getRect())
        toca15_ = v43
        ball_.update()
        evil16_.update()
        v44 = figureCollision(ball_.getRect(),evil16_.getRect())
        toca16_ = v44
        ball_.update()
        evil17_.update()
        v45 = figureCollision(ball_.getRect(),evil17_.getRect())
        toca17_ = v45
        ball_.update()
        evil18_.update()
        v46 = figureCollision(ball_.getRect(),evil18_.getRect())
        toca18_ = v46
        ball_.update()
        evil19_.update()
        v47 = figureCollision(ball_.getRect(),evil19_.getRect())
        toca19_ = v47
        ball_.update()
        evil20_.update()
        v48 = figureCollision(ball_.getRect(),evil20_.getRect())
        toca20_ = v48
        ball_.update()
        evil21_.update()
        v49 = figureCollision(ball_.getRect(),evil21_.getRect())
        toca21_ = v49
        ball_.update()
        evil6_.update()
        v50 = figureCollision(ball_.getRect(),evil6_.getRect())
        toca6_ = v50
        ball_.update()
        evil7_.update()
        v51 = figureCollision(ball_.getRect(),evil7_.getRect())
        toca7_ = v51
        ball_.update()
        evil8_.update()
        v52 = figureCollision(ball_.getRect(),evil8_.getRect())
        toca8_ = v52
        ball_.update()
        evil9_.update()
        v53 = figureCollision(ball_.getRect(),evil9_.getRect())
        toca9_ = v53
        ball_.update()
        evil10_.update()
        v54 = figureCollision(ball_.getRect(),evil10_.getRect())
        toca10_ = v54
        ball_.update()
        evil11_.update()
        v55 = figureCollision(ball_.getRect(),evil11_.getRect())
        toca11_ = v55
        ball_.update()
        evil12_.update()
        v56 = figureCollision(ball_.getRect(),evil12_.getRect())
        toca12_ = v56
        ball_.update()
        evil13_.update()
        v57 = figureCollision(ball_.getRect(),evil13_.getRect())
        toca13_ = v57
        ball_.update()
        evil5_.update()
        v58 = figureCollision(ball_.getRect(),evil5_.getRect())
        toca5_ = v58
        ball_.update()
        evil4_.update()
        v59 = figureCollision(ball_.getRect(),evil4_.getRect())
        toca4_ = v59
        ball_.update()
        evil3_.update()
        v60 = figureCollision(ball_.getRect(),evil3_.getRect())
        toca3_ = v60
        ball_.update()
        evil2_.update()
        v61 = figureCollision(ball_.getRect(),evil2_.getRect())
        toca2_ = v61
        ball_.update()
        evil1_.update()
        v62 = figureCollision(ball_.getRect(),evil1_.getRect())
        toca1_ = v62
        v64 = plataforma_.collideEdge(WIDTH, HEIGHT)
        v65 = True
        v63 = v64 == v65
        if (v63):
            v67 = playerSpeed_
            v68 = -2
            v66 = v67 * v68
            v69 = 0
            plataforma_.translate(v66, v69)
            v71 = playerSpeed_
            v72 = -1
            v70 = v71 * v72
            playerSpeed_ = v70

        try:
            if eventos[0].type == pygame.KEYDOWN and eventos[0].key == pygame.K_LEFT:
                v73 = -4
                playerSpeed_ = v73
        except:
            pass
        try:
            if eventos[0].type == pygame.KEYDOWN and eventos[0].key == pygame.K_RIGHT:
                v74 = 4
                playerSpeed_ = v74
        except:
            pass
        v76 = math.floor(internal_timer/100)
        v77 = 1
        v75 = v76 < v77
        if (v75):
            v78 = speedx_
            v79 = speedy_
            ball_.translate(v78, v79)
        else:
            v81 = tocaBase_
            v82 = True
            v80 = v81 == v82
            if (v80):
                break

            v84 = tocaPlat_
            v85 = True
            v83 = v84 == v85
            if (v83):
                v87 = speedy_
                v88 = -1
                v86 = v87 * v88
                speedy_ = v86
                v89 = random.randint(1,5)
                speedx_ = v89
                v90 = random.randint(1,2)
                direction_ = v90
                v92 = direction_
                v93 = 2
                v91 = v92 == v93
                if (v91):
                    v95 = speedx_
                    v96 = -1
                    v94 = v95 * v96
                    speedx_ = v94


            v98 = tocaDireita_
            v99 = True
            v97 = v98 == v99
            if (v97):
                v101 = speedx_
                v102 = -1
                v100 = v101 * v102
                speedx_ = v100

            v104 = tocaEsquerda_
            v105 = True
            v103 = v104 == v105
            if (v103):
                v107 = speedx_
                v108 = -1
                v106 = v107 * v108
                speedx_ = v106

            v110 = tocaTopo_
            v111 = True
            v109 = v110 == v111
            if (v109):
                v113 = speedy_
                v114 = -1
                v112 = v113 * v114
                speedy_ = v112

            v116 = toca14_
            v117 = True
            v115 = v116 == v117
            if (v115):
                v119 = toques_
                v120 = 1
                v118 = v119 - v120
                toques_ = v118
                v122 = speedy_
                v123 = -1
                v121 = v122 * v123
                speedy_ = v121
                v124 = True
                evil14_.hidden = v124
                v126 = plataforma_.x2
                v127 = 4
                v125 = v126 - v127
                plataforma_.x2 = v125
                v129 = plataforma_.x3
                v130 = 4
                v128 = v129 - v130
                plataforma_.x3 = v128

            v132 = toca15_
            v133 = True
            v131 = v132 == v133
            if (v131):
                v135 = toques_
                v136 = 1
                v134 = v135 - v136
                toques_ = v134
                v138 = speedy_
                v139 = -1
                v137 = v138 * v139
                speedy_ = v137
                v140 = True
                evil15_.hidden = v140
                v142 = plataforma_.x2
                v143 = 4
                v141 = v142 - v143
                plataforma_.x2 = v141
                v145 = plataforma_.x3
                v146 = 4
                v144 = v145 - v146
                plataforma_.x3 = v144

            v148 = toca16_
            v149 = True
            v147 = v148 == v149
            if (v147):
                v151 = toques_
                v152 = 1
                v150 = v151 - v152
                toques_ = v150
                v154 = speedy_
                v155 = -1
                v153 = v154 * v155
                speedy_ = v153
                v156 = True
                evil16_.hidden = v156
                v158 = plataforma_.x2
                v159 = 4
                v157 = v158 - v159
                plataforma_.x2 = v157
                v161 = plataforma_.x3
                v162 = 4
                v160 = v161 - v162
                plataforma_.x3 = v160

            v164 = toca17_
            v165 = True
            v163 = v164 == v165
            if (v163):
                v167 = toques_
                v168 = 1
                v166 = v167 - v168
                toques_ = v166
                v170 = speedy_
                v171 = -1
                v169 = v170 * v171
                speedy_ = v169
                v172 = True
                evil17_.hidden = v172
                v174 = plataforma_.x2
                v175 = 4
                v173 = v174 - v175
                plataforma_.x2 = v173
                v177 = plataforma_.x3
                v178 = 4
                v176 = v177 - v178
                plataforma_.x3 = v176

            v180 = toca18_
            v181 = True
            v179 = v180 == v181
            if (v179):
                v183 = toques_
                v184 = 1
                v182 = v183 - v184
                toques_ = v182
                v186 = speedy_
                v187 = -1
                v185 = v186 * v187
                speedy_ = v185
                v188 = True
                evil18_.hidden = v188
                v190 = plataforma_.x2
                v191 = 4
                v189 = v190 - v191
                plataforma_.x2 = v189
                v193 = plataforma_.x3
                v194 = 4
                v192 = v193 - v194
                plataforma_.x3 = v192

            v196 = toca19_
            v197 = True
            v195 = v196 == v197
            if (v195):
                v199 = toques_
                v200 = 1
                v198 = v199 - v200
                toques_ = v198
                v202 = speedy_
                v203 = -1
                v201 = v202 * v203
                speedy_ = v201
                v204 = True
                evil19_.hidden = v204
                v206 = plataforma_.x2
                v207 = 4
                v205 = v206 - v207
                plataforma_.x2 = v205
                v209 = plataforma_.x3
                v210 = 4
                v208 = v209 - v210
                plataforma_.x3 = v208

            v212 = toca20_
            v213 = True
            v211 = v212 == v213
            if (v211):
                v215 = toques_
                v216 = 1
                v214 = v215 - v216
                toques_ = v214
                v218 = speedy_
                v219 = -1
                v217 = v218 * v219
                speedy_ = v217
                v220 = True
                evil20_.hidden = v220
                v222 = plataforma_.x2
                v223 = 4
                v221 = v222 - v223
                plataforma_.x2 = v221
                v225 = plataforma_.x3
                v226 = 4
                v224 = v225 - v226
                plataforma_.x3 = v224

            v228 = toca21_
            v229 = True
            v227 = v228 == v229
            if (v227):
                v231 = toques_
                v232 = 1
                v230 = v231 - v232
                toques_ = v230
                v234 = speedy_
                v235 = -1
                v233 = v234 * v235
                speedy_ = v233
                v236 = True
                evil21_.hidden = v236
                v238 = plataforma_.x2
                v239 = 4
                v237 = v238 - v239
                plataforma_.x2 = v237
                v241 = plataforma_.x3
                v242 = 4
                v240 = v241 - v242
                plataforma_.x3 = v240

            v244 = toca13_
            v245 = True
            v243 = v244 == v245
            if (v243):
                v247 = toques_
                v248 = 1
                v246 = v247 - v248
                toques_ = v246
                v250 = speedy_
                v251 = -1
                v249 = v250 * v251
                speedy_ = v249
                v252 = True
                evil13_.hidden = v252
                v254 = plataforma_.x2
                v255 = 4
                v253 = v254 - v255
                plataforma_.x2 = v253
                v257 = plataforma_.x3
                v258 = 4
                v256 = v257 - v258
                plataforma_.x3 = v256

            v260 = toca12_
            v261 = True
            v259 = v260 == v261
            if (v259):
                v263 = toques_
                v264 = 1
                v262 = v263 - v264
                toques_ = v262
                v266 = speedy_
                v267 = -1
                v265 = v266 * v267
                speedy_ = v265
                v268 = True
                evil12_.hidden = v268
                v270 = plataforma_.x2
                v271 = 4
                v269 = v270 - v271
                plataforma_.x2 = v269
                v273 = plataforma_.x3
                v274 = 4
                v272 = v273 - v274
                plataforma_.x3 = v272

            v276 = toca11_
            v277 = True
            v275 = v276 == v277
            if (v275):
                v279 = toques_
                v280 = 1
                v278 = v279 - v280
                toques_ = v278
                v282 = speedy_
                v283 = -1
                v281 = v282 * v283
                speedy_ = v281
                v284 = True
                evil11_.hidden = v284
                v286 = plataforma_.x2
                v287 = 4
                v285 = v286 - v287
                plataforma_.x2 = v285
                v289 = plataforma_.x3
                v290 = 4
                v288 = v289 - v290
                plataforma_.x3 = v288

            v292 = toca10_
            v293 = True
            v291 = v292 == v293
            if (v291):
                v295 = toques_
                v296 = 1
                v294 = v295 - v296
                toques_ = v294
                v298 = speedy_
                v299 = -1
                v297 = v298 * v299
                speedy_ = v297
                v300 = True
                evil10_.hidden = v300
                v302 = plataforma_.x2
                v303 = 4
                v301 = v302 - v303
                plataforma_.x2 = v301
                v305 = plataforma_.x3
                v306 = 4
                v304 = v305 - v306
                plataforma_.x3 = v304

            v308 = toca9_
            v309 = True
            v307 = v308 == v309
            if (v307):
                v311 = toques_
                v312 = 1
                v310 = v311 - v312
                toques_ = v310
                v314 = speedy_
                v315 = -1
                v313 = v314 * v315
                speedy_ = v313
                v316 = True
                evil9_.hidden = v316
                v318 = plataforma_.x2
                v319 = 4
                v317 = v318 - v319
                plataforma_.x2 = v317
                v321 = plataforma_.x3
                v322 = 4
                v320 = v321 - v322
                plataforma_.x3 = v320

            v324 = toca8_
            v325 = True
            v323 = v324 == v325
            if (v323):
                v327 = toques_
                v328 = 1
                v326 = v327 - v328
                toques_ = v326
                v330 = speedy_
                v331 = -1
                v329 = v330 * v331
                speedy_ = v329
                v332 = True
                evil8_.hidden = v332
                v334 = plataforma_.x2
                v335 = 4
                v333 = v334 - v335
                plataforma_.x2 = v333
                v337 = plataforma_.x3
                v338 = 4
                v336 = v337 - v338
                plataforma_.x3 = v336

            v340 = toca6_
            v341 = True
            v339 = v340 == v341
            if (v339):
                v343 = toques_
                v344 = 1
                v342 = v343 - v344
                toques_ = v342
                v346 = speedy_
                v347 = -1
                v345 = v346 * v347
                speedy_ = v345
                v348 = True
                evil6_.hidden = v348
                v350 = plataforma_.x2
                v351 = 4
                v349 = v350 - v351
                plataforma_.x2 = v349
                v353 = plataforma_.x3
                v354 = 4
                v352 = v353 - v354
                plataforma_.x3 = v352

            v356 = toca7_
            v357 = True
            v355 = v356 == v357
            if (v355):
                v359 = toques_
                v360 = 1
                v358 = v359 - v360
                toques_ = v358
                v362 = speedy_
                v363 = -1
                v361 = v362 * v363
                speedy_ = v361
                v364 = True
                evil7_.hidden = v364
                v366 = plataforma_.x2
                v367 = 4
                v365 = v366 - v367
                plataforma_.x2 = v365
                v369 = plataforma_.x3
                v370 = 4
                v368 = v369 - v370
                plataforma_.x3 = v368

            v372 = toca5_
            v373 = True
            v371 = v372 == v373
            if (v371):
                v375 = toques_
                v376 = 1
                v374 = v375 - v376
                toques_ = v374
                v378 = speedy_
                v379 = -1
                v377 = v378 * v379
                speedy_ = v377
                v380 = True
                evil5_.hidden = v380
                v382 = plataforma_.x2
                v383 = 4
                v381 = v382 - v383
                plataforma_.x2 = v381
                v385 = plataforma_.x3
                v386 = 4
                v384 = v385 - v386
                plataforma_.x3 = v384

            v388 = toca4_
            v389 = True
            v387 = v388 == v389
            if (v387):
                v391 = toques_
                v392 = 1
                v390 = v391 - v392
                toques_ = v390
                v394 = speedy_
                v395 = -1
                v393 = v394 * v395
                speedy_ = v393
                v396 = True
                evil4_.hidden = v396
                v398 = plataforma_.x2
                v399 = 4
                v397 = v398 - v399
                plataforma_.x2 = v397
                v401 = plataforma_.x3
                v402 = 4
                v400 = v401 - v402
                plataforma_.x3 = v400

            v404 = toca3_
            v405 = True
            v403 = v404 == v405
            if (v403):
                v407 = toques_
                v408 = 1
                v406 = v407 - v408
                toques_ = v406
                v410 = speedy_
                v411 = -1
                v409 = v410 * v411
                speedy_ = v409
                v412 = True
                evil3_.hidden = v412
                v414 = plataforma_.x2
                v415 = 4
                v413 = v414 - v415
                plataforma_.x2 = v413
                v417 = plataforma_.x3
                v418 = 4
                v416 = v417 - v418
                plataforma_.x3 = v416

            v420 = toca2_
            v421 = True
            v419 = v420 == v421
            if (v419):
                v423 = toques_
                v424 = 1
                v422 = v423 - v424
                toques_ = v422
                v426 = speedy_
                v427 = -1
                v425 = v426 * v427
                speedy_ = v425
                v428 = True
                evil2_.hidden = v428
                v430 = plataforma_.x2
                v431 = 4
                v429 = v430 - v431
                plataforma_.x2 = v429
                v433 = plataforma_.x3
                v434 = 4
                v432 = v433 - v434
                plataforma_.x3 = v432

            v436 = toca1_
            v437 = True
            v435 = v436 == v437
            if (v435):
                v439 = toques_
                v440 = 1
                v438 = v439 - v440
                toques_ = v438
                v442 = speedy_
                v443 = -1
                v441 = v442 * v443
                speedy_ = v441
                v444 = True
                evil1_.hidden = v444
                v446 = plataforma_.x2
                v447 = 4
                v445 = v446 - v447
                plataforma_.x2 = v445
                v449 = plataforma_.x3
                v450 = 4
                v448 = v449 - v450
                plataforma_.x3 = v448

            v452 = toques_
            v453 = 0
            v451 = v452 == v453
            if (v451):
                v454 = True
                terminou_ = v454

            v455 = speedx_
            v456 = speedy_
            ball_.translate(v455, v456)

        v458 = terminou_
        v459 = False
        v457 = v458 == v459
        if (v457):
            evil1_.update()
            if(evil1_.hidden == False):
                pygame.draw.polygon(display, evil1_.color, evil1_.points, evil1_.thickness)
            evil2_.update()
            if(evil2_.hidden == False):
                pygame.draw.polygon(display, evil2_.color, evil2_.points, evil2_.thickness)
            evil3_.update()
            if(evil3_.hidden == False):
                pygame.draw.polygon(display, evil3_.color, evil3_.points, evil3_.thickness)
            evil4_.update()
            if(evil4_.hidden == False):
                pygame.draw.polygon(display, evil4_.color, evil4_.points, evil4_.thickness)
            evil5_.update()
            if(evil5_.hidden == False):
                pygame.draw.polygon(display, evil5_.color, evil5_.points, evil5_.thickness)
            evil6_.update()
            if(evil6_.hidden == False):
                pygame.draw.polygon(display, evil6_.color, evil6_.points, evil6_.thickness)
            evil7_.update()
            if(evil7_.hidden == False):
                pygame.draw.polygon(display, evil7_.color, evil7_.points, evil7_.thickness)
            evil8_.update()
            if(evil8_.hidden == False):
                pygame.draw.polygon(display, evil8_.color, evil8_.points, evil8_.thickness)
            evil9_.update()
            if(evil9_.hidden == False):
                pygame.draw.polygon(display, evil9_.color, evil9_.points, evil9_.thickness)
            evil10_.update()
            if(evil10_.hidden == False):
                pygame.draw.polygon(display, evil10_.color, evil10_.points, evil10_.thickness)
            evil11_.update()
            if(evil11_.hidden == False):
                pygame.draw.polygon(display, evil11_.color, evil11_.points, evil11_.thickness)
            evil12_.update()
            if(evil12_.hidden == False):
                pygame.draw.polygon(display, evil12_.color, evil12_.points, evil12_.thickness)
            evil13_.update()
            if(evil13_.hidden == False):
                pygame.draw.polygon(display, evil13_.color, evil13_.points, evil13_.thickness)
            evil14_.update()
            if(evil14_.hidden == False):
                pygame.draw.polygon(display, evil14_.color, evil14_.points, evil14_.thickness)
            evil15_.update()
            if(evil15_.hidden == False):
                pygame.draw.polygon(display, evil15_.color, evil15_.points, evil15_.thickness)
            evil16_.update()
            if(evil16_.hidden == False):
                pygame.draw.polygon(display, evil16_.color, evil16_.points, evil16_.thickness)
            evil17_.update()
            if(evil17_.hidden == False):
                pygame.draw.polygon(display, evil17_.color, evil17_.points, evil17_.thickness)
            evil18_.update()
            if(evil18_.hidden == False):
                pygame.draw.polygon(display, evil18_.color, evil18_.points, evil18_.thickness)
            evil19_.update()
            if(evil19_.hidden == False):
                pygame.draw.polygon(display, evil19_.color, evil19_.points, evil19_.thickness)
            evil20_.update()
            if(evil20_.hidden == False):
                pygame.draw.polygon(display, evil20_.color, evil20_.points, evil20_.thickness)
            evil21_.update()
            if(evil21_.hidden == False):
                pygame.draw.polygon(display, evil21_.color, evil21_.points, evil21_.thickness)
            left_.update()
            if(left_.hidden == False):
                pygame.draw.polygon(display, left_.color, left_.points, left_.thickness)
            right_.update()
            if(right_.hidden == False):
                pygame.draw.polygon(display, right_.color, right_.points, right_.thickness)
            bottom_.update()
            if(bottom_.hidden == False):
                pygame.draw.polygon(display, bottom_.color, bottom_.points, bottom_.thickness)
            top_.update()
            if(top_.hidden == False):
                pygame.draw.polygon(display, top_.color, top_.points, top_.thickness)
            if(ball_.hidden == False):
                pygame.draw.circle(display,ball_.color,(ball_.x,ball_.y),ball_.r,ball_.thickness)
            plataforma_.update()
            if(plataforma_.hidden == False):
                pygame.draw.polygon(display, plataforma_.color, plataforma_.points, plataforma_.thickness)
        else:
            vitoria_ = f"Vitoria"
            contador__ = vitoria_
            if(isinstance(vitoria_, int)):
                contador__ = str(vitoria_)

            font = pygame.font.Font('freesansbold.ttf', 70)
            text = font.render(contador__, True, ORANGE_, BLACK_)
            textRect = text.get_rect()
            textRect.center = (600, 400)
            drawstringlllll_ = True


        internal_timer = internal_timer + 1
        pygame.display.update()
pygame.quit()
