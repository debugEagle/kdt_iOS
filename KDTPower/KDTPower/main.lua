

log('aux begin')

sleep(1000)

init(1)

--pressKey(64)

--touchDown(1, 50, 150);
--sleep(200)
--touchMove(1, 250, 150);
--sleep(200)
--touchUp(1, 50, 150);

color = getColor(0, 0)

log('0,0: '..string.format("%08x",color))

x, y = findColorEx(0xdbd095,"6|13|6f6442,11|-6|271c0a,-74|89|efc575", 0, 0, 1136, 640, 1.0, 0)

log(x..','..y)


dict = {
	"10027E4949292524A49492FFFA4A4949292524A4FC8010020000010420C7CC000008811022047088110227FC1FE10120340080$重试$1.0.211$18"
}

dm.SetDict(0, dict);

w = 1136
h = 640

t1 = os.clock ()
for i=1,1 do
    x,y,m = dm.FindStr(0, 0, w, h, "重试","e2b465-303030", 1.0, 1)
    print("FindStr0.9",x,y)
    touchDown(1, x, y)
    sleep(200)
    touchUp(1, x, y)
end
log(os.clock () - t1)

log('aux end')
