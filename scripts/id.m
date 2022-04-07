yp = data_head_openloop.get('w pitch').Values;
yr = data_head_openloop.get('w roll').Values;
up = data_head_openloop.get('pid_pitch').Values;
ur = data_head_openloop.get('pid_roll').Values;
up = resample(up, yp.Time);
ur = resample(ur, yr.Time);