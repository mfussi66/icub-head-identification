yp = data_head_openloop.get('pitch').Values;
yr = data_head_openloop.get('roll').Values;
ydp = data_head_openloop.get('w pitch').Values;
ydr = data_head_openloop.get('w roll').Values;
up = data_head_openloop.get('pid_pitch').Values;
ur = data_head_openloop.get('pid_roll').Values;
up = resample(up, yp.Time);
ur = resample(ur, yr.Time);

kt = 0;
jp = 1e-8;
kv = 0;
l = 1e-8;
b = 0.00001;