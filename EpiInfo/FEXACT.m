//
//  FEXACT.m
//  EpiInfo
//
//  Created by John Copeland on 7/28/20.
//

#import "FEXACT.h"
#import "EIDoubleArray.h"
#import "EIIntArray.h"

@implementation FEXACT
+ (float)FEXACT:(NSArray *)SortedRows
{
    NSMutableArray *table0 = [[NSMutableArray alloc] init];
    for (int i = 0; i <= [SortedRows count]; i++)
    {
        NSMutableArray *nsma = [[NSMutableArray alloc] init];
        [nsma addObject:[NSNumber numberWithInt:0]];
        if (i == 0)
        {
            for (int j = 1; j < [(NSArray *)[SortedRows objectAtIndex:i] count]; j++)
            {
                [nsma addObject:[NSNumber numberWithInt:0]];
            }
            [table0 addObject:[NSArray arrayWithArray:nsma]];
            continue;
        }
        NSArray *dr = (NSArray *)[SortedRows objectAtIndex:i - 1];
        for (int j = 1; j < [dr count]; j++)
        {
            if (i == 0)
                [nsma addObject:[NSNumber numberWithInt:0]];
            else
                [nsma addObject:[NSNumber numberWithInt:[[dr objectAtIndex:j] intValue]]];
        }
        [table0 addObject:[NSArray arrayWithArray:nsma]];
    }
    
    NSArray *table = [NSArray arrayWithArray:table0];
    
    if ([table count] > [(NSArray *)[table objectAtIndex:0] count])
        table = [self transposeMatrix:table];

    int ncol = (int)[(NSArray *)[table objectAtIndex:0] count] - 1;
    int nrow = (int)[table count] - 1;
    int ldtabl = nrow;
    double expect = 0.0;
    double percent = 90.0;
    double emin = 1.0;
    double prt = 0.0;
    double pre = 0.0;
    
    int iwkmax = 200000;
    int mult = 30;
    int ireal = 4;
    double amiss = -12345.0;
    int iwkpt = 1;
    int ntot = 0;
    
    for (int r = 1; r <= nrow; r++)
    {
        for (int c = 1; c <= ncol; c++)
        {
            ntot += [(NSNumber *)[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue];
        }
    }
    
    int nco = ncol;
    int nro = nrow;
    int k = nrow + ncol + 1;
    int kk = k * ncol;
    int ldkey, ldstp, numb;
    
    int i1 = [self iwork:iwkmax with:&iwkpt and:ntot + 1 and:ireal] - 1;
    int i2 = [self iwork:iwkmax with:&iwkpt and:nco and:2] - 1;
    int i3 = [self iwork:iwkmax with:&iwkpt and:nco and:2] - 1;
    int i3a = [self iwork:iwkmax with:&iwkpt and:nco and:2] - 1;
    int i3b = [self iwork:iwkmax with:&iwkpt and:nro and:2] - 1;
    int i3c = [self iwork:iwkmax with:&iwkpt and:nro and:2] - 1;
    int iiwk = [self iwork:iwkmax with:&iwkpt and:MAX(5 * k + 2 * kk, 800 + 7 * ncol) and:2] - 1;
    int irwk = [self iwork:iwkmax with:&iwkpt and:MAX(400 + ncol + 1, k) and:ireal] - 1;
    
    if (ireal == 4)
    {
        numb = 18 + 10 * mult;
        ldkey = (iwkmax - iwkpt + 1) / numb;
    }
    else
    {
        numb = 12 * 8 * mult;
        ldkey = (iwkmax - iwkpt + 1) / numb;
    }
    
    ldstp = mult * ldkey;
    int i4 = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:2] - 1;
    int i5 = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:2] - 1;
    int i6 = [self iwork:iwkmax with:&iwkpt and:2 * ldstp and:ireal] - 1;
    int i7 = [self iwork:iwkmax with:&iwkpt and:6 * ldstp and:2] - 1;
    int i8 = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:ireal] - 1;
    int i9 = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:ireal] - 1;
    int i9a = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:ireal] - 1;
    int i10 = [self iwork:iwkmax with:&iwkpt and:2 * ldkey and:2] - 1;

    EIDoubleArray *i1array = [[EIDoubleArray alloc] initWithCapacity:irwk];
    EIIntArray *i2array = [[EIIntArray alloc] initWithCapacity:i3 - i2 + 1];
    EIIntArray *i3array = [[EIIntArray alloc] initWithCapacity:i3a - i3 + 1];
    EIIntArray *i3aarray = [[EIIntArray alloc] initWithCapacity:i3b - i3a + 1];
    EIIntArray *i3barray = [[EIIntArray alloc] initWithCapacity:i3c - i3b + 1];
    EIIntArray *i3carray = [[EIIntArray alloc] initWithCapacity:iiwk - i3c + 1];
    EIIntArray *i4array = [[EIIntArray alloc] initWithCapacity:i5 - i4 + 1];
    EIIntArray *i5array = [[EIIntArray alloc] initWithCapacity:i7 - i5 + 1];
    EIDoubleArray *i6array = [[EIDoubleArray alloc] initWithCapacity:i8 - i6 + 1];
    EIIntArray *i7array = [[EIIntArray alloc] initWithCapacity:i10 - i7 + 1];
    EIDoubleArray *i8array = [[EIDoubleArray alloc] initWithCapacity:i9 - i8 + 1];
    EIDoubleArray *i9array = [[EIDoubleArray alloc] initWithCapacity:i9a - i9 + 1];
    EIDoubleArray *i9aarray = [[EIDoubleArray alloc] initWithCapacity:iwkmax - i9a + 1];
    EIIntArray *i10array = [[EIIntArray alloc] initWithCapacity:2 * ldkey + 1];
    EIIntArray *iiwkarray = [[EIIntArray alloc] initWithCapacity:i4 - iiwk + 1];
    EIDoubleArray *irwkarray = [[EIDoubleArray alloc] initWithCapacity:i6 - irwk + 1];

    [self f2xact:nrow and:ncol and:table and:ldtabl and:expect and:percent and:emin and:&prt and:&pre and:i1array and:i2array and:i3array and:i3aarray and:i3barray and:i3carray and:i4array and:ldkey and:i5array and:ldstp and:i6array and:i7array and:i8array and:i9array and:i9aarray and:i10array and:iiwkarray and:irwkarray];
    NSLog(@"%f, %f, %f, %d", prt, pre, [i1array numberAtIndex:2], [i2array numberAtIndex:1]);

    return pre;
}

+ (void)f2xact:(int)nrow and:(int)ncol and:(NSArray *)table and:(int)ldtabl and:(double)expect and:(double)percnt and:(double)emin and:(double*)prt and:(double*)pre and:(EIDoubleArray *)fact and:(EIIntArray *)ico and:(EIIntArray *)iro and:(EIIntArray *)kyy and:(EIIntArray *)idif and:(EIIntArray *)irn and:(EIIntArray *)key and:(int)ldkey and:(EIIntArray *)ipoin and:(int)ldstp and:(EIDoubleArray *)stp and:(EIIntArray *)ifrq and:(EIDoubleArray *)dlp and:(EIDoubleArray *)dsp and:(EIDoubleArray *)tm and:(EIIntArray *)key2 and:(EIIntArray *)iwk and:(EIDoubleArray *)rwk
{
    int f5itp = 0;

    for (int i = 1; i <= 2 * ldkey; i++)
    {
        [key setNumber:-9999 atIndex:i];
        [key2 setNumber:-9999 atIndex:i];
    }
    int preops = 0;

    int ncell;
    int ifault = 1;
    int iflag = 1;
    double tmp = 0.0;
    double pv;
    double df;
    double obs2;
    double obs3;
    bool chisq = false;

    *pre = 0.0;
    int itop = 0;
    double emn = 0.0;
    double emx = 1.0e30;
    double tol = 3.45254e-7;
    double amiss = -12345.0;
    double imax = 2147483647;

    if (expect > 0.0)
    {
        emn = emin;
    }
    else
    {
        emn = emx;
    }

    int k = ncol;

    // Variables for f3xact
    int i31 = 1;
    int i32 = i31 + k;
    int i33 = i32 + k;
    int i34 = i33 + k;
    int i35 = i34 + k;
    int i36 = i35 + k;
    int i37 = i36 + k;
    int i38 = i37 + k;
    int i39 = i38 + 400;
    int i310 = 1;
    int i311 = 401;

    // Variables for f4xact
    k = nrow + ncol + 1;
    int i41 = 1;
    int i42 = i41 + k;
    int i43 = i42 + k;
    int i44 = i43 + k;
    int i45 = i44 + k;
    int i46 = i45 + k;
    int i47 = i46 + k * ncol;
    int i48 = 1;

    if (nrow > ldtabl)
    {
        return;
    }
    if (ncol <= 1)
    {
        return;
    }

    int ntot = 0;
    EIIntArray *nint = [[EIIntArray alloc] initWithCapacity:[self maxTableCell:nrow and:ncol and:table] + 1];
    for (int r = 1; r <= nrow; r++)
    {
        [iro setNumber:0 atIndex:r];
        for (int c = 1; c <= ncol; c++)
        {
            if ([[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue] < -0.0001)
            {
                return;
            }
            [iro setNumber:[iro numberAtIndex:r] + [[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue] atIndex:r];
            ntot += [[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue];
        }
    }
    // Resize iro and to the proper row size
    EIIntArray *riro = [[EIIntArray alloc] initWithCapacity:nrow + 1];
    for (int r = 1; r <= nrow; r++)
    {
        [riro setNumber:[iro numberAtIndex:r] atIndex:r];
    }
    iro = riro;

    if (ntot == 0)
    {
        *prt = amiss;
        *pre = amiss;
        return;
    }

    for (int c = 1; c <= ncol; c++)
    {
        [ico setNumber:0 atIndex:c];
        for (int r = 1; r <= nrow; r++)
        {
            [ico setNumber:[ico numberAtIndex:c] + [[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue] atIndex:c];
        }
    }
    // Resize ico to the proper column size
    EIIntArray *rico = [[EIIntArray alloc] initWithCapacity:ncol + 1];
    for (int c = 1; c <= ncol; c++)
    {
        [rico setNumber:[ico numberAtIndex:c] atIndex:c];
    }
    ico = rico;
    
    [iro sort];
    [ico sort];

    int nro = nrow;
    int nco = ncol;

    EIIntArray *rkyy = [[EIIntArray alloc] initWithCapacity:nro + 1];
    [rkyy setNumber:1 atIndex:1];
    int mj = ncol;
    for (int r = 2; r <= nro; r++)
    {
        if ([iro numberAtIndex:r - 1] + 1 <= imax / [rkyy numberAtIndex:r - 1])
        {
            [rkyy setNumber:[rkyy numberAtIndex:r - 1] * ([iro numberAtIndex:r - 1] + 1) atIndex:r];
            mj = mj / [rkyy numberAtIndex:r - 1];
        }
        else
        {
            [rkyy setNumber:[rkyy numberAtIndex:r - 1] * ([iro numberAtIndex:r - 1] + 1) atIndex:r];
            mj = mj / [rkyy numberAtIndex:r - 1];
        }
    }
    kyy = rkyy;

    int kmax;
    if ([iro numberAtIndex:nro - 1] + 1 <= imax / [kyy numberAtIndex:nro - 1])
    {
        kmax = ([iro numberAtIndex:nro] + 1) * [kyy numberAtIndex:nro - 1];
    }
    else
    {
        kmax = ([iro numberAtIndex:nro] + 1) * [kyy numberAtIndex:nro - 1];
    }

    [fact setNumber:0.0 atIndex:0];
    [fact setNumber:0.0 atIndex:1];
    [fact setNumber:log(2.0) atIndex:2];
    for (int i = 3; i <= ntot; i += 2)
    {
        [fact setNumber:[fact numberAtIndex:i - 1] + log((double)i) atIndex:i];
        mj = i + 1;
        if (mj <= ntot)
        {
            [fact setNumber:[fact numberAtIndex:i] + [fact numberAtIndex:2] + [fact numberAtIndex:mj / 2] - [fact numberAtIndex:mj / 2 - 1] atIndex:mj];
        }
    }

    double obs = tol;
    ntot = 0;
    double dd = 0.0;
    for (mj = 1; mj <= nco; mj++)
    {
        dd = 0.0;
        for (int r = 1; r <= nro; r++)
        {
            dd = dd + [fact numberAtIndex:[[(NSArray *)[table objectAtIndex:r] objectAtIndex:mj] intValue]];
            ntot = ntot + [[(NSArray *)[table objectAtIndex:r] objectAtIndex:mj] intValue];
        }
        obs = obs + [fact numberAtIndex:[ico numberAtIndex:mj]] - dd;
    }
    double dro = [self f9xact:nro and:ntot and:iro and:1 and:fact];
    *prt = exp(obs - dro);

    // Initialize pointers
    k = nco;
    int last = ldkey + 1;
    int jkey = ldkey + 1;
    int jstp = ldstp + 1;
    int jstp2 = 3 * ldstp + 1;
    int jstp3 = 4 * ldstp + 1;
    int jstp4 = 5 * ldstp + 1;
    int ikkey = 0;
    int ikstp = 0;
    int ikstp2 = 2 * ldstp;
    int ipo = 1;
    [ipoin setNumber:1 atIndex:1];
    [stp setNumber:0.0 atIndex:1];
    [ifrq setNumber:1 atIndex:1];
    [ifrq setNumber:-1 atIndex:ikstp2 + 1];

    //           bool goto110 = true;
goto110:;
    int kb = nco - k + 1;
    int ks = 0;
    int n = [ico numberAtIndex:kb]; //Ends up being the lowest column total
    int kd = nro + 1;
    kmax = nro;

    for (int i = 1; i <= nro; i++)
    {
        [idif setNumber:0 atIndex:i];
    }

goto130:;
    kd = kd - 1; // So kd is now highest index of row totals vector
    ntot = MIN(n, [iro numberAtIndex:kd]); // The lowest column total or the highest row total??
    [idif setNumber:ntot atIndex:kd];
    if ([idif numberAtIndex:kmax] == 0)
    {
        kmax = kmax - 1;
    }
    n = n - ntot;
    if (n > 0 && kd != 1)
    {
        goto goto130;
    }

    int k1;
    if (n != 0)
    {
        goto goto310;
    }

    k1 = k - 1;
    n = [ico numberAtIndex:kb];
    ntot = 0;
    // kb began as 1 less than the FORTRAN value so this is the same as in FORTRAN
    for (int i = kb + 1; i <= nco; i++)
    {
        ntot = ntot + [ico numberAtIndex:i];
    }

    goto150:
    for (int i = 1; i <= nro; i++)
    {
        [irn setNumber:[iro numberAtIndex:i] - [idif numberAtIndex:i] atIndex:i];
    }

    int nrb = 0;
    int nro2 = 0;
    int ii = 0;
    if (k1 > 1)
    {
        int i = nro;
        if (nro == 2)
        {
            if ([irn numberAtIndex:1] > [irn numberAtIndex:2])
            {
                ii = [irn numberAtIndex:1];
                [irn setNumber:[irn numberAtIndex:2] atIndex:1];
                [irn setNumber:ii atIndex:2];
            }
        }
        else if (nro == 3)
        {
            ii = [irn numberAtIndex:1];
            if (ii > [irn numberAtIndex:3])
            {
                if (ii > [irn numberAtIndex:2])
                {
                    if ([irn numberAtIndex:2] > [irn numberAtIndex:3])
                    {
                        [irn setNumber:[irn numberAtIndex:3] atIndex:1];
                        [irn setNumber:ii atIndex:3];
                    }
                    else
                    {
                        [irn setNumber:[irn numberAtIndex:1] atIndex:1];
                        [irn setNumber:[irn numberAtIndex:2] atIndex:2];
                        [irn setNumber:ii atIndex:3];
                    }
                }
                else
                {
                    [irn setNumber:[irn numberAtIndex:3] atIndex:1];
                    [irn setNumber:[irn numberAtIndex:2] atIndex:3];
                    [irn setNumber:ii atIndex:2];
                }
            }
            else if (ii > [irn numberAtIndex:2])
            {
                [irn setNumber:[irn numberAtIndex:2] atIndex:1];
                [irn setNumber:ii atIndex:2];
            }
            else if ([irn numberAtIndex:2] > [irn numberAtIndex:3])
            {
                ii = [irn numberAtIndex:2];
                [irn setNumber:[irn numberAtIndex:3] atIndex:2];
                [irn setNumber:ii atIndex:3];
            }
        }
        else
        {
            for (int j = 2; j <= nro; j++)
            {
                i = j - 1;
                ii = [irn numberAtIndex:j];
            goto170:;
                if (ii < [irn numberAtIndex:i])
                {
                    [irn setNumber:[irn numberAtIndex:i] atIndex:i + 1];
                    i--;
                    if (i > 0)
                    {
                        goto goto170;
                    }
                }

                [irn setNumber:ii atIndex:i + 1];
            }
        }
        for (i = 1; i <= nro; i++)
        {
            if ([irn numberAtIndex:i] != 0)
            {
                goto goto200;
            }
        }
    goto200:;
        nrb = i;
        nro2 = nro - i + 1;
    }
    else
    {
        nrb = 1;
        nro2 = nro;
    }

    // The "Sort irn" section of the FORTRAN program
    // I think it does important things besides sorting an array

    // Some table values
    double ddf = [self f9xact:nro and:n and:idif and:1 and:fact];
    double drn = [self f9xact:nro2 and:ntot and:irn and:nrb and:fact] - dro + ddf;

    // Get hash values
    int itp = 0;
    int kval = 1;
    if (k1 > 1)
        { // REVISIT: FORTRAN has if k1 gt 1
            // All of these indices are reduced by 1 from FORTRAN
            kval = [irn numberAtIndex:1] + [irn numberAtIndex:2] * [kyy numberAtIndex:2];
            int i = 2;
            for (i = 3; i <= nro; i++)
            {
                kval = kval + [irn numberAtIndex:i] * [kyy numberAtIndex:i];
            }

            // Get hash table entry
            i = kval % (2 * ldkey) + 1;

            // Search for unused location
            for (itp = i; itp <= 2 * ldkey; itp++)
            {
                ii = [key2 numberAtIndex:itp];
                if (ii == kval)
                {
                    goto goto240;
                }
                else if (ii < 0)
                {
                    [key2 setNumber:kval atIndex:itp];
                    [dlp setNumber:1.0 atIndex:itp];
                    [dsp setNumber:1.0 atIndex:itp];
                    goto goto240;
                }
            }

            for (itp = 1; itp <= i - 1; itp++)
            {
                ii = [key2 numberAtIndex:itp];
                if (ii == kval)
                {
                    goto goto240;
                }
                else if (ii < 0)
                {
                    [key2 setNumber:kval atIndex:itp];
                    [dlp setNumber:1.0 atIndex:itp];
                    goto goto240;
                }
            }
        }

goto240:;
                BOOL ipsh = YES;

                // Recover pastp
                int ipn = [ipoin numberAtIndex:ipo + ikkey];
                double pastp = [stp numberAtIndex:ipn + ikstp];
                int ifreq = [ifrq numberAtIndex:ipn + ikstp];
                // REVISIT: Had to use the min function bc ipn+ikstp was out of bounds

                // Compute shortest and longest path
                if (k1 > 1)
                { // REVISIT: FORTRAN says .gt. 1
                    obs2 = obs - [fact numberAtIndex:[ico numberAtIndex:kb + 1]] - [fact numberAtIndex:[ico numberAtIndex:kb + 2]] - ddf;
                    for (int i = 3; i <= k1; i++)
                    {
                        obs2 = obs2 - [fact numberAtIndex:[ico numberAtIndex:kb + i]];
                    }

                    if ([dlp numberAtIndex:itp] > 0.0)
                    {
                        double dspt = obs - obs2 - ddf;
                        // Compute longest path
                        [dlp setNumber:0.0 atIndex:itp];
                        // First need separate work arrays
//                        int[] iwk0 = new int[iwk.Length];
//                        int[] iwk1 = new int[iwk.Length];
//                        int[] iwk2 = new int[iwk.Length];
//                        int[] iwk3 = new int[iwk.Length];
//                        int[] iwk4 = new int[iwk.Length];
//                        int[] iwk5 = new int[iwk.Length];
//                        int[] iwk6 = new int[iwk.Length];
//                        int[] iwk7 = new int[iwk.Length];
//                        int[] iwk8 = new int[iwk.Length];
                        EIIntArray *iwk0 = [iwk copy];
                        EIIntArray *iwk1 = [iwk copy];
                        EIIntArray *iwk2 = [iwk copy];
                        EIIntArray *iwk3 = [iwk copy];
                        EIIntArray *iwk4 = [iwk copy];
                        EIIntArray *iwk5 = [iwk copy];
                        EIIntArray *iwk6 = [iwk copy];
                        EIIntArray *iwk7 = [iwk copy];
                        EIIntArray *iwk8 = [iwk copy];
//                        Array.Copy(iwk, iwk0, iwk.Length);
//                        Array.Copy(iwk, iwk1, iwk.Length);
//                        Array.Copy(iwk, iwk2, iwk.Length);
//                        Array.Copy(iwk, iwk3, iwk.Length);
//                        Array.Copy(iwk, iwk4, iwk.Length);
//                        Array.Copy(iwk, iwk5, iwk.Length);
//                        Array.Copy(iwk, iwk6, iwk.Length);
//                        Array.Copy(iwk, iwk7, iwk.Length);
//                        Array.Copy(iwk, iwk8, iwk.Length);
//                        double[] rwk0 = new double[rwk.Length];
//                        double[] rwk1 = new double[rwk.Length];
                        EIDoubleArray *rwk0 = [rwk copy];
                        EIDoubleArray *rwk1 = [rwk copy];
//                        Array.Copy(rwk, rwk0, rwk.Length);
//                        Array.Copy(rwk, rwk1, rwk.Length);
                        //
//                        f3xact(nro2, irn, nrb, k1, ico, kb + 1, ref dlp[itp],
//                               ref ntot, fact, iwk0, iwk1, iwk2,
//                               iwk3, iwk4, iwk5, iwk6,
//                               iwk7, iwk8, rwk0, rwk1, tol);
                        double dlpitp = [dlp numberAtIndex:itp];
                        [self f3xact:nro2 and:irn and:nrb and:k1 and:ico and:kb + 1 and:&dlpitp and:&ntot and:fact and:iwk0 and:iwk1 and:iwk2 and:iwk3 and:iwk4 and:iwk5 and:iwk6 and:iwk7 and:iwk8 and:rwk0 and:rwk1 and:tol];
                        [dlp setNumber:dlpitp atIndex:itp];
                        [dlp setNumber:MIN(0.0, [dlp numberAtIndex:itp]) atIndex:itp];

                        // Compute shortest path
                        [dsp setNumber:dspt atIndex:itp];
                        double dspitp = [dsp numberAtIndex:itp];
                        NSLog(@"dspitp = %f", dspitp);
	                        [self f4xact:nro2 and:irn and:nrb and:k1 and:ico and:kb + 1 and:&dspitp and:fact and:iwk0 and:iwk1 and:iwk2 and:iwk3 and:iwk4 and:iwk5 and:iwk6 and:rwk0 and:tol];
                        NSLog(@"dspitp = %f", dspitp);
                        [dsp setNumber:dspitp atIndex:itp];
                        NSLog(@"dsp[itp] = %f", [dsp numberAtIndex:itp]);
                        [dsp setNumber:MIN(0.0, [dsp numberAtIndex:itp] - dspt) atIndex:itp];
                        NSLog(@"dsp[itp] = %f", [dsp numberAtIndex:itp]);

                        // Use chi-squared approximation
                        if ((double)(([irn numberAtIndex:nrb] * [ico numberAtIndex:kb + 1]) / (double)ntot) > emn)
                        {
                            ncell = 0;
                            for (int j = 1; j <= nro2; j++)
                            {
                                for (int l = 1; l <= k1; l++)
                                {
                                    if ([irn numberAtIndex:nrb + j - 1] * [ico numberAtIndex:kb + l] >= ntot * expect)
                                    {
                                        ncell = ncell + 1;
                                    }
                                }
                            }
                            if (ncell * 100 >= k1 * nro2 * percnt)
                            {
                                tmp = 0.0;
                                for (int j = 1; j <= nro2; j++)
                                {
                                    tmp = tmp + [fact numberAtIndex:[irn numberAtIndex:nrb + j - 1]] - [fact numberAtIndex:[irn numberAtIndex:nrb + j - 1] - 1];
                                }
                                tmp = tmp * (k1 - 1);
                                for (int j = 1; j <= k1; j++)
                                {
                                    tmp = tmp + (nro2 - 1) * ([fact numberAtIndex:[ico numberAtIndex:kb + j]] - [fact numberAtIndex:[ico numberAtIndex:kb + j] - 1]);
                                }
                                df = (nro2 - 1) * (k1 - 1);
                                tmp = tmp + df * 1.83787706640934548356065947281;
                                tmp = tmp - (nro2 * k1 - 1) * ([fact numberAtIndex:ntot] - [fact numberAtIndex:ntot - 1]);
                                [tm setNumber:-2.0 * (obs - dro) - tmp atIndex:itp];
                            }
                            else
                            {
                                [tm setNumber:-9876.0 atIndex:itp];
                            }
                        }
                        else
                        {
                            [tm setNumber:-9876.0 atIndex:itp];
                        }
                    }
                    obs3 = obs2 - [dlp numberAtIndex:itp];
                    obs2 = obs2 - [dsp numberAtIndex:itp];
                    if ([tm numberAtIndex:itp] == -9876.0)
                    {
                        chisq = false;
                    }
                    else
                    {
                        chisq = true;
                        tmp = [tm numberAtIndex:itp];
                    }
                }
                else
                {
                    obs2 = obs - drn - dro;
                    obs3 = obs2;
                }
                // Process node with new PASTP
                // bool goto300 = true;
                goto300:
                if (pastp <= obs3)
                {
                    *pre = *pre + ifreq * exp(pastp + drn);
                    preops++;
                    if (preops == 106 || preops == 13)
                    {
                        bool checkpoint = true;
                    }
                }
                else if (pastp < obs2)
                {
                    if (chisq)
                    {
                        df = (nro2 - 1) * (k1 - 1);
                        pv = [self gamds:MAX(0.0, tmp + 2.0 * (pastp + drn)) / 2.0 and:df / 2.0 and:ifault];
                        *pre = *pre + ifreq * exp(pastp + drn) * pv;
                    }
                    else
                    {
                        // Put daughter on queue
                        [self f5xact:pastp + ddf and:tol and:kval and:&key and:jkey and:ldkey and:&ipoin and:jkey and:&stp and:jstp and:ldstp and:&ifrq and:jstp and:&ifrq and:jstp2 and:&ifrq and:jstp3 and:&ifrq and:jstp4 and:ifreq and:&itop and:ipsh and:&f5itp];
                        ipsh = false;
                    }
                }
                // Get next PASTP on chain
                ipn = [ifrq numberAtIndex:ipn + ikstp2];
                if (ipn > 0)
                {
                    pastp = [stp numberAtIndex:ipn + ikstp];
                    ifreq = [ifrq numberAtIndex:ipn + ikstp];
                    goto goto300;
                }
                // Generate new daughter node
                [self f7xact:kmax and:iro and:&idif and:&kd and:&ks and:&iflag];
                if (iflag != 1)
                {
                    goto goto150;
                }
                // Go get a new mother from stage K
                // bool goto310 = true;
                goto310:
                iflag = 1;
                [self f6xact:nro and:&iro and:&iflag and:kyy and:&key and:ikkey + 1 and:ldkey and:&last and:&ipo];
                if (iflag == 3)
                {
                    k = k - 1;
                    itop = 0;
                    ikkey = jkey - 1;
                    ikstp = jstp - 1;
                    ikstp2 = jstp2 - 1;
                    jkey = ldkey - jkey + 2;
                    jstp = ldstp - jstp + 2;
                    jstp2 = 2 * ldstp + jstp;
                    for (int f = 1; f <= 2 * ldkey; f++)
                    {
                        [key2 setNumber:-9999 atIndex:f];
                    }
                    if (k >= 2)
                    {
                        goto goto310;
                    }
                }
                else
                {
                    // goto310 = false;
                    // goto110 = true;
                    goto goto110;
                }
}

+ (void)f3xact:(int)nrow and:(EIIntArray*)irow and:(int)irowoffset and:(int)ncol and:(EIIntArray*)icol and:(int)icoloffset and:(double*)dlp and:(int*)mm and:(EIDoubleArray*)fact and:(EIIntArray*)ico and:(EIIntArray*)iro and:(EIIntArray*)it and:(EIIntArray*)lb and:(EIIntArray*)nr and:(EIIntArray*)nt and:(EIIntArray*)nu and:(EIIntArray*)itc and:(EIIntArray*)ist and:(EIDoubleArray*)stv and:(EIDoubleArray*)alen and:(double)tol
{
    int n11 = 0;
    int n12 = 0;
    int nro;
    int nco;
    double val;
    int nn;
    bool xmin;
    int nitc = 0;
    int nst = 0;
    int nn1 = 0;
    int nc1 = 0;
    int ic1 = 0;
    int ic2 = 0;
    int ii = 0;
    int key = 0;
    int ipn = 0;
    int itp = 0;

    for (int i = 0; i <= ncol; i++)
    {
        [alen setNumber:0.0 atIndex:i];
    }
    for (int i = 1; i <= 400; i++)
    {
        [ist setNumber:-1 atIndex:i];
    }

    // nrow is 1
    if (nrow <= 1)
    {
        if (nrow > 0)
        {
            *dlp = *dlp - [fact numberAtIndex:[icol numberAtIndex:1]];
            for (int i = 2; i <= ncol; i++)
            {
                *dlp = *dlp - [fact numberAtIndex:[icol numberAtIndex:i + icoloffset - 1]];
            }
        }
        return;
    }

    // ncol is 1
    if (ncol <= 1)
    {
        if (ncol > 0)
        {
            *dlp = *dlp - [fact numberAtIndex:[irow numberAtIndex:1]] - [fact numberAtIndex:[irow numberAtIndex:2]];
            for (int i = 3; i <= nrow; i++)
            {
                *dlp = *dlp - [fact numberAtIndex:[irow numberAtIndex:i + irowoffset - 1]];
            }
        }
        return;
    }

    // 2 by 2 table
    if (nrow * ncol == 4)
    {
        n11 = ([irow numberAtIndex:1 + irowoffset - 1] + 1) * ([icol numberAtIndex:1 + icoloffset - 1] + 1) / (*mm + 2);
        n12 = [irow numberAtIndex:1 + irowoffset - 1] - n11;
        *dlp = *dlp - [fact numberAtIndex:n11] - [fact numberAtIndex:n12] - [fact numberAtIndex:[icol numberAtIndex:1 + icoloffset - 1] - n11] - [fact numberAtIndex:[icol numberAtIndex:2 + icoloffset - 1] - n12];
        return;
    }

    // Test for optimal table
    val = 0.0;
    xmin = false;
    if ([irow numberAtIndex:nrow + irowoffset - 1] <= [irow numberAtIndex:1 + irowoffset - 1] + ncol)
    {
        [self f10act:nrow and:irow and:irowoffset and:ncol and:icol and:icoloffset and:&val and:&xmin and:fact and:lb and:nu and:nr];
    }
    if (!xmin)
    {
        if ([icol numberAtIndex:ncol + icoloffset - 1] <= [icol numberAtIndex:1 + icoloffset - 1] + nrow)
        {
            [self f10act:ncol and:icol and:icoloffset and:nrow and:irow and:irowoffset and:&val and:&xmin and:fact and:lb and:nu and:nr];
        }
    }

    if (xmin)
    {
        *dlp = *dlp - val;
        return;
    }

    // Setup for dynamic programming
    nn = *mm;

    // Minimize ncol
    if (nrow >= ncol)
    {
        nro = nrow;
        nco = ncol;

        for (int i = 1; i <= nrow; i++)
        {
            [iro setNumber:[irow numberAtIndex:i + irowoffset - 1] atIndex:i];
        }

        [ico setNumber:[icol numberAtIndex:1 + icoloffset - 1] atIndex:1];
        [nt setNumber:nn - [ico numberAtIndex:1] atIndex:1];
        for (int i = 2; i <= ncol; i++)
        {
            [ico setNumber:[icol numberAtIndex:i + icoloffset - 1] atIndex:i];
            [nt setNumber:[nt numberAtIndex:i - 1] - [ico numberAtIndex:i] atIndex:i];
        }
    }
    else
    {
        nro = ncol;
        nco = nrow;

        [ico setNumber:[irow numberAtIndex:1 + irowoffset - 1] atIndex:1];
        [nt setNumber:nn - [ico numberAtIndex:1] atIndex:1];
        for (int i = 2; i <= nrow; i++)
        {
            [ico setNumber:[irow numberAtIndex:i + irowoffset - 1] atIndex:i];
            [nt setNumber:[nt numberAtIndex:i - 1] - [ico numberAtIndex:i] atIndex:i];
        }
        for (int i = 1; i <= ncol; i++)
        {
            [iro setNumber:[icol numberAtIndex:i + icoloffset - 1] atIndex:i];
        }
    }

    // Initialize pointers
    double vmn = 1.0e10;
    int nc1s = nco - 1;
    int irl = 1;
    int ks = 0;
    int ldst = 200;
    int k = ldst;
    int kyy = [ico numberAtIndex:nco] + 1;
    goto goto100;

    goto90:
    xmin = false;
    if ([iro numberAtIndex:nro - 1] <= [iro numberAtIndex:irl - 1] + nco)
    {
        [self f10act:nro and:iro and:irl and:nco and:ico and:1 and:&val and:&xmin and:fact and:lb and:nu and:nr];
    }
    if (!xmin)
    {
        if ([ico numberAtIndex:nco - 1] <= [ico numberAtIndex:0] + nro)
        {
            [self f10act:nco and:ico and:1 and:nro and:iro and:irl and:&val and:&xmin and:fact and:lb and:nu and:nr];
        }
    }
    if (xmin)
    {
        if (val < vmn)
        {
            vmn = val;
        }
        goto goto200;
    }

goto100:;
    int lev = 1;
    int nr1 = nro - 1;
    int nrt = [iro numberAtIndex:irl];
    int nct = [ico numberAtIndex:1];
    [lb setNumber:(int)((double)((nrt + 1) * (nct + 1)) / (double)(nn + nr1 * nc1s + 1) - tol) - 1 atIndex:1];
    [nu setNumber:(int)((double)((nrt + nc1s) * (nct + nr1)) / (double)(nn + nr1 * nc1s)) - [lb numberAtIndex:1] + 1 atIndex:1];
    [nr setNumber:nrt - [lb numberAtIndex:1] atIndex:1];

    goto110:
    [nu setNumber:[nu numberAtIndex:lev] - 1 atIndex:lev];
    if ([nu numberAtIndex:lev] == 0)
    {
        if (lev == 1)
        {
            goto goto200;
        }
        lev--;
        goto goto110;
    }
    [lb setNumber:[lb numberAtIndex:lev] + 1 atIndex:lev];
    [nr setNumber:[nr numberAtIndex:lev] - 1 atIndex:lev];

    goto120:
    [alen setNumber:[alen numberAtIndex:lev - 1] + [fact numberAtIndex:[lb numberAtIndex:lev]] atIndex:lev];
    if (lev < nc1s)
    {
        nn1 = [nt numberAtIndex:lev];
        nrt = [nr numberAtIndex:lev];
        lev = lev + 1;
        nc1 = nco - lev;
        nct = [ico numberAtIndex:lev];
        [lb setNumber:(int)((double)((nrt + 1) * (nct + 1)) / (double)(nn1 + nr1 * nc1 + 1) - tol) atIndex:lev];
        [nu setNumber:(int)((double)((nrt + nc1) * (nct + nr1)) / (double)(nn1 + nr1 + nc1) - [lb numberAtIndex:lev] + 1) atIndex:lev];
        [nr setNumber:nrt - [lb numberAtIndex:lev] atIndex:lev];
        goto goto120;
    }
    [alen setNumber:[alen numberAtIndex:lev] + [fact numberAtIndex:[nr numberAtIndex:lev]] atIndex:nco];
    [lb setNumber:[nr numberAtIndex:lev] atIndex:nco];

    double v = val + [alen numberAtIndex:nco];

    if (nro == 2)
    {
        v = v + [fact numberAtIndex:[ico numberAtIndex:1] - [lb numberAtIndex:1]] + [fact numberAtIndex:[ico numberAtIndex:2] - [lb numberAtIndex:2]];
        for (int i = 3; i <= nco; i++)
        {
            v = v + [fact numberAtIndex:[ico numberAtIndex:i] - [lb numberAtIndex:i]];
        }
        if (v < vmn)
        {
            vmn = v;
        }
    }
    else if (nro == 3 && nco == 2)
    {
        nn1 = nn - [iro numberAtIndex:irl] + 2;
        ic1 = [ico numberAtIndex:1] - [lb numberAtIndex:1];
        ic2 = [ico numberAtIndex:2] - [lb numberAtIndex:2];
        n11 = ([iro numberAtIndex:irl + 1] + 1) * (ic1 + 1) / nn1;
        n12 = [iro numberAtIndex:irl + 1] - n11;
        v = v + [fact numberAtIndex:n11] + [fact numberAtIndex:n12] + [fact numberAtIndex:ic1 - n11] + [fact numberAtIndex:ic2 - n12];
        if (v < vmn)
        {
            vmn = v;
        }
    }
    else
    {
        for (int i = 1; i <= nco; i++)
        {
            [it setNumber:[ico numberAtIndex:i] - [lb numberAtIndex:i] atIndex:i];
        }
        if (nco == 2)
        {
            if ([it numberAtIndex:1] > [it numberAtIndex:2])
            {
                ii = [it numberAtIndex:1];
                [it setNumber:[it numberAtIndex:2] atIndex:1];
                [it setNumber:ii atIndex:2];
            }
        }
        else if (nco == 3)
        {
            ii = [it numberAtIndex:1];
            if (ii > [it numberAtIndex:3])
            {
                if (ii > [it numberAtIndex:2])
                {
                    if ([it numberAtIndex:2] > [it numberAtIndex:3])
                    {
                        [it setNumber:[it numberAtIndex:3] atIndex:1];
                        [it setNumber:ii atIndex:3];
                    }
                    else
                    {
                        [it setNumber:[it numberAtIndex:2] atIndex:1];
                        [it setNumber:[it numberAtIndex:3] atIndex:2];
                        [it setNumber:ii atIndex:3];
                    }
                }
                else
                {
                    [it setNumber:[it numberAtIndex:3] atIndex:1];
                    [it setNumber:[it numberAtIndex:2] atIndex:3];
                    [it setNumber:ii atIndex:2];
                }
            }
            else if (ii > [it numberAtIndex:2])
            {
                [it setNumber:[it numberAtIndex:2] atIndex:1];
                [it setNumber:ii atIndex:2];
            }
            else if ([it numberAtIndex:2] > [it numberAtIndex:3])
            {
                ii = [it numberAtIndex:2];
                [it setNumber:[it numberAtIndex:3] atIndex:2];
                [it setNumber:ii atIndex:3];
            }
        }
        else
        {
            [it sort];
        }

        key = [it numberAtIndex:1] * kyy + [it numberAtIndex:2];
        for (int i = 3; i <= nco; i++)
        {
            key = [it numberAtIndex:i] + key * kyy;
        }

        ipn = key % ldst + 1;

        ii = ks + ipn;
        for (itp = ipn; itp <= ldst; ipn++)
        {
            if ([ist numberAtIndex:ii] < 0)
            {
                goto goto180;
            }
            else if ([ist numberAtIndex:ii] == key)
            {
                goto goto190;
            }
            ii++;
        }

        ii = ks + 1;
        for (itp = 1; itp <= ipn - 1; itp++)
        {
            if ([ist numberAtIndex:ii] < 0)
            {
                goto goto180;
            }
            else if ([ist numberAtIndex:ii] == key)
            {
                goto goto190;
            }
            ii++;
        }

        goto180:
        [ist setNumber:key atIndex:ii];
        [stv setNumber:v atIndex:ii];
        nst++;
        ii = nst + ks;
        [itc setNumber:itp atIndex:ii];
        goto goto110;

        goto190:
        [stv setNumber:MIN(v, [stv numberAtIndex:ii]) atIndex:ii];
    }
    goto goto110;

    goto200:
    if (nitc > 0)
    {
        itp = [itc numberAtIndex:nitc + k] + k;
        nitc--;
        val = [stv numberAtIndex:itp];
        key = [ist numberAtIndex:itp];
        [ist setNumber:-1 atIndex:itp];
        for (int i = nco; i >= 2; i--)
        {
            [ico setNumber:key % kyy atIndex:i];
            key = key / kyy;
        }
        [ico setNumber:key atIndex:1];

        [nt setNumber:nn - [ico numberAtIndex:1] atIndex:1];
        for (int i = 2; i <= nco; i++)
        {
            [nt setNumber:[nt numberAtIndex:i - 1] - [ico numberAtIndex:i] atIndex:i];
        }
        goto goto90;
    }
    else if (nro > 2 && nst > 0)
    {
        nitc = nst;
        nst = 0;
        k = ks;
        ks = ldst - ks;
        nn = nn - [iro numberAtIndex:irl];
        irl++;
        nro--;
        goto goto200;
    }

    *dlp = *dlp - vmn;
}

+ (void)f4xact:(int)nrow and:(EIIntArray*)irow and:(int)irowoffset and:(int)ncol and:(EIIntArray*)icol and:(int)icoloffset and:(double*)dsp and:(EIDoubleArray*)fact and:(EIIntArray*)icstkk and:(EIIntArray*)ncstk and:(EIIntArray*)lstk and:(EIIntArray*)mstk and:(EIIntArray*)nstk and:(EIIntArray*)nrstk and:(EIIntArray*)irstkk and:(EIDoubleArray*)ystk and:(double)tol
{
    int i = 1;
    int j = 1;
    int irstk[nrow + ncol + 1][nrow + ncol + 1];
    for (i = 0; i <= nrow + ncol; i++)
    {
        for (int j = 0; j <= nrow + ncol; j++)
        {
            irstk[i][j] = 0;
        }
    }
    int icstk[nrow + ncol + 1][nrow + ncol + 1];
    for (i = 1; i <= ncol + nrow; i++)
    {
        for (int j = 0; j <= nrow + ncol; j++)
        {
            icstk[i][j] = 0;
        }
    }

    if (nrow == 1)
    {
        for (i = 1; i <= ncol; i++)
        {
            *dsp = *dsp - [fact numberAtIndex:[icol numberAtIndex:i + icoloffset - 1]];
        }
        return;
    }

    if (ncol == 1)
    {
        for (i = 1; i <= nrow; i++)
        {
            *dsp = *dsp - [fact numberAtIndex:[irow numberAtIndex:i + irowoffset - 1]];
        }
        goto goto9000;
    }

    if (nrow * ncol == 4)
    {
        if ([irow numberAtIndex:2 + irowoffset - 1] <= [icol numberAtIndex:2 + icoloffset - 1])
        {
            *dsp = *dsp - [fact numberAtIndex:[irow numberAtIndex:2 + irowoffset - 1]] - [fact numberAtIndex:[icol numberAtIndex:1 + icoloffset - 1]] - [fact numberAtIndex:[icol numberAtIndex:2 + icoloffset - 1] - [irow numberAtIndex:2 + irowoffset - 1]];
        }
        else
        {
            *dsp = *dsp - [fact numberAtIndex:[icol numberAtIndex:2 + icoloffset - 1]] - [fact numberAtIndex:[irow numberAtIndex:1 + irowoffset - 1]] - [fact numberAtIndex:[irow numberAtIndex:2 + irowoffset - 1] - [icol numberAtIndex:2 + icoloffset - 1]];
        }
        goto goto9000;
    }

    // initialization before loop
    for (i = 1; i <= nrow; i++)
    {
        irstk[1][i] = [irow numberAtIndex:nrow - i + 1 + irowoffset - 1];
    }
    for (j = 1; j <= ncol; j++)
    {
        icstk[1][j] = [icol numberAtIndex:ncol - j + 1 + icoloffset - 1];
    }

    int nro = nrow;
    int nco = ncol;
    [nrstk setNumber:nro atIndex:1];
    [ncstk setNumber:nco atIndex:1];
    [ystk setNumber:0.0 atIndex:1];
    double y = 0.0;
    int istk = 1;
    int l = 1;
    double amx = 0.0;

goto50:;
    int ir1 = irstk[istk][1];
    int ic1 = icstk[istk][1];
    int m = 0;
    int n = 0;
    int k = 0;
    int mn = 0;
    if (ir1 > ic1)
    {
        if (nro >= nco)
        {
            m = nco - 1;
            n = 2;
        }
        else
        {
            m = nro;
            n = 1;
        }
    }
    else if (ir1 < ic1)
    {
        if (nro <= nco)
        {
            m = nro - 1;
            n = 1;
        }
        else
        {
            m = nco;
            n = 2;
        }
    }
    else
    {
        if (nro <= nco)
        {
            m = nro - 1;
            n = 1;
        }
        else
        {
            m = nco - 1;
            n = 2;
        }
    }

    goto60:
    if (n == 1)
    {
        i = l;
        j = 1;
    }
    else
    {
        i = 1;
        j = l;
    }

    int irt = irstk[istk][i];
    int ict = icstk[istk][j];
    mn = irt;
    if (mn > ict)
    {
        mn = ict;
    }
    y = y + [fact numberAtIndex:mn];
    if (irt == ict)
    {
        nro = nro - 1;
        nco = nco - 1;
        EIIntArray *irstkIA = [[EIIntArray alloc] initWithCArray:irstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *irstkIA1 = [[EIIntArray alloc] initWithCArray:irstk[istk + 1] ofSize:nrow + ncol + 1];
        [self f11act:irstkIA and:1 and:i and:nro and:irstkIA1 and:1];
        EIIntArray *icstkIA = [[EIIntArray alloc] initWithCArray:icstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *icstkIA1 = [[EIIntArray alloc] initWithCArray:icstk[istk + 1] ofSize:nrow + ncol + 1];
        [self f11act:icstkIA and:1 and:j and:nco and:icstkIA1 and:1];
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            icstk[istk][tk] = [icstkIA numberAtIndex:tk];
            icstk[istk + 1][tk] = [icstkIA1 numberAtIndex:tk];
        }
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            irstk[istk][tk] = [irstkIA numberAtIndex:tk];
            irstk[istk + 1][tk] = [irstkIA1 numberAtIndex:tk];
        }
    }
    else if (irt >= ict)
    {
        nco = nco - 1;
        EIIntArray *irstkIA = [[EIIntArray alloc] initWithCArray:irstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *irstkIA1 = [[EIIntArray alloc] initWithCArray:irstk[istk + 1] ofSize:nrow + ncol + 1];
        EIIntArray *icstkIA = [[EIIntArray alloc] initWithCArray:icstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *icstkIA1 = [[EIIntArray alloc] initWithCArray:icstk[istk + 1] ofSize:nrow + ncol + 1];
        [self f11act:icstkIA and:1 and:j and:nco and:icstkIA1 and:1];
        [self f8xact:irstkIA and:1 and:irt - ict and:i and:nro and:&irstkIA1 and:1];
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            icstk[istk][tk] = [icstkIA numberAtIndex:tk];
            icstk[istk + 1][tk] = [icstkIA1 numberAtIndex:tk];
        }
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            irstk[istk][tk] = [irstkIA numberAtIndex:tk];
            irstk[istk + 1][tk] = [irstkIA1 numberAtIndex:tk];
        }
    }
    else
    {
        nro = nro - 1;
        EIIntArray *icstkIA = [[EIIntArray alloc] initWithCArray:icstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *icstkIA1 = [[EIIntArray alloc] initWithCArray:icstk[istk + 1] ofSize:nrow + ncol + 1];
        EIIntArray *irstkIA = [[EIIntArray alloc] initWithCArray:irstk[istk] ofSize:nrow + ncol + 1];
        EIIntArray *irstkIA1 = [[EIIntArray alloc] initWithCArray:irstk[istk + 1] ofSize:nrow + ncol + 1];
        [self f11act:irstkIA and:1 and:i and:nro and:irstkIA1 and:1];
        [self f8xact:icstkIA and:1 and:ict - irt and:j and:nco and:&icstkIA1 and:1];
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            icstk[istk][tk] = [icstkIA numberAtIndex:tk];
            icstk[istk + 1][tk] = [icstkIA1 numberAtIndex:tk];
        }
        for (int tk = 0; tk < [icstkIA.nsma count]; tk++)
        {
            irstk[istk][tk] = [irstkIA numberAtIndex:tk];
            irstk[istk + 1][tk] = [irstkIA1 numberAtIndex:tk];
        }
    }

    if (nro == 1)
    {
        for (k = 1; k <= nco; k++)
        {
            y = y + [fact numberAtIndex:icstk[istk + 1][k]];
        }
        goto goto90;
    }

    if (nco == 1)
    {
        for (k = 1; k <= nro; k++)
        {
            y = y + [fact numberAtIndex:irstk[istk + 1][k]];
        }
        goto goto90;
    }

    [lstk setNumber:l atIndex:istk];
    [mstk setNumber:m atIndex:istk];
    [nstk setNumber:n atIndex:istk];
    istk++;
    [nrstk setNumber:nro atIndex:istk];
    [ncstk setNumber:nco atIndex:istk];
    [ystk setNumber:y atIndex:istk];
    l = 1;
    goto goto50;

    goto90:
    if (y > amx)
    {
        amx = y;
        if (*dsp - amx <= tol)
        {
            *dsp = 0.0;
            goto goto9000;
        }
    }

    goto100:
    istk--;
    if (istk == 0)
    {
        *dsp = *dsp - amx;
        if (*dsp - amx <= tol)
        {
            *dsp = 0.0;
        }
        goto goto9000;
    }
    l = [lstk numberAtIndex:istk] + 1;

    goto110:
    if (l > [mstk numberAtIndex:istk])
    {
        goto goto100;
    }
    n = [nstk numberAtIndex:istk];
    nro = [nrstk numberAtIndex:istk];
    nco = [ncstk numberAtIndex:istk];
    y = [ystk numberAtIndex:istk];
    if (n == 1)
    {
        if (irstk[istk][l] < irstk[istk][l - 1])
        {
            goto goto60;
        }
    }
    else if (n == 2)
    {
        if (icstk[istk][l] < icstk[istk][l - 1])
        {
            goto goto60;
        }
    }

    l++;
    goto goto110;

    goto9000:
    return;
}

+ (void)f5xact:(double)pastp and:(double)tol and:(int)kval and:(EIIntArray**)key and:(int)keyoffset and:(int)ldkey and:(EIIntArray**)ipoin and:(int)ipoinoffset and:(EIDoubleArray**)stp and:(int)stpoffset and:(int)ldstp and:(EIIntArray**)ifrq and:(int)ifrqoffset and:(EIIntArray**)npoin and:(int)npoinoffset and:(EIIntArray**)nr and:(int)nroffset and:(EIIntArray**)nl and:(int)nloffset and:(int)ifreq and:(int*)itop and:(BOOL)ipsh and:(int*)itp
{
    int ird = 1;
    int ipn = 1;

    if (ipsh)
    {
        ird = (kval % ldkey) + 1;

        for (*itp = ird; *itp <= ldkey; (*itp)++)
        {
            if ([*key numberAtIndex:*itp + keyoffset - 1] == kval)
            {
                goto goto40;
            }
            if ([*key numberAtIndex:*itp + keyoffset - 1] < 0)
            {
                goto goto30;
            }
        }
        for (*itp = 1; *itp <= ird - 1; (*itp)++)
        {
            if ([*key numberAtIndex:*itp + keyoffset - 1] == kval)
            {
                goto goto40;
            }
            if ([*key numberAtIndex:*itp + keyoffset - 1] < 0)
            {
                goto goto30;
            }
        }

        goto30:
        [*key setNumber:kval atIndex:*itp + keyoffset - 1];
        (*itop)++;
        [*ipoin setNumber:*itop atIndex:*itp + ipoinoffset - 1];
        if (*itop > ldstp)
        {
        }
        [*npoin setNumber:-1 atIndex:*itop + npoinoffset - 1];
        [*nr setNumber:-1 atIndex:*itop + nroffset - 1];
        [*nl setNumber:-1 atIndex:*itop + nloffset - 1];
        [*stp setNumber:pastp atIndex:*itop + stpoffset - 1];
        [*ifrq setNumber:ifreq atIndex:*itop + ifrqoffset - 1];
        return;
    }
    goto40:
    ipn = [*ipoin numberAtIndex:*itp + ipoinoffset - 1];
    double test1 = pastp - tol;
    double test2 = pastp + tol;

    goto50:
    if ([*stp numberAtIndex:ipn + stpoffset - 1] < test1)
    {
        ipn = [*nl numberAtIndex:ipn + nloffset - 1];
        if (ipn > 0)
        {
            goto goto50;
        }
    }
    else if ([*stp numberAtIndex:ipn + stpoffset - 1] > test2)
    {
        ipn = [*nr numberAtIndex:ipn + nroffset - 1];
        if (ipn > 0)
        {
            goto goto50;
        }
    }
    else
    {
        [*ifrq setNumber:[*ifrq numberAtIndex:ipn + ifrqoffset - 1] + ifreq atIndex:ipn + ifrqoffset - 1];
        return;
    }

    *itop = *itop + 1;
    if (*itop > ldstp)
    {
    }

    ipn = [*ipoin numberAtIndex:*itp + ipoinoffset - 1];
    int itmp = ipn;
    goto60:
    if ([*stp numberAtIndex:ipn + stpoffset - 1] < test1)
    {
        itmp = ipn;
        ipn = [*nl numberAtIndex:ipn + nloffset - 1];
        if (ipn > 0)
        {
            goto goto60;
        }
        else
        {
            [*nl setNumber:*itop atIndex:itmp + nloffset - 1];
        }
    }
    else if ([*stp numberAtIndex:ipn + stpoffset - 1] > test2)
    {
        itmp = ipn;
        ipn = [*nr numberAtIndex:ipn + nroffset - 1];
        if (ipn > 0)
        {
            goto goto60;
        }
        else
        {
            [*nr setNumber:*itop atIndex:itmp + nroffset - 1];
        }
    }

    [*npoin setNumber:[*npoin numberAtIndex:itmp + npoinoffset - 1] atIndex:*itop + npoinoffset - 1];
    [*npoin setNumber:*itop atIndex:itmp + npoinoffset - 1];
    [*stp setNumber:pastp atIndex:*itop + stpoffset - 1];
    [*ifrq setNumber:ifreq atIndex:*itop + ifrqoffset - 1];
    [*nl setNumber:-1 atIndex:*itop + nloffset - 1];
    [*nr setNumber:-1 atIndex:*itop + nroffset - 1];
}

+ (void)f6xact:(int)nrow and:(EIIntArray **)irow and:(int*)iflag and:(EIIntArray *)kyy and:(EIIntArray **)key and:(int)keyoffset and:(int)ldkey and:(int*)last and:(int*)ipn
{
    int kval;
    goto10:
    *last = *last + 1;
    if (*last <= ldkey)
    {
        if ([*key numberAtIndex:*last + keyoffset - 1] < 0)
        {
            goto goto10;
        }
        kval = [*key numberAtIndex:*last + keyoffset - 1];
        [*key setNumber:-9999 atIndex:*last + keyoffset - 1];
        for (int j = nrow; j >= 2; j--)
        {
            [*irow setNumber:kval / [kyy numberAtIndex:j] atIndex:j];
            kval = kval - [*irow numberAtIndex:j] * [kyy numberAtIndex:j];
        }
        [*irow setNumber:kval atIndex:1];
        *ipn = *last;
    }
    else
    {
        *last = 0;
        *iflag = 3;
    }
}

+ (void)f7xact:(int)nrow and:(EIIntArray *)imax and:(EIIntArray **)idif and:(int*)k and:(int*)ks and:(int*)iflag
{
    int m = 0;
    int k1 = 0;
    int mm = 0;
    *iflag = 0;

    if (*ks == 0)
    {
        goto10:
        *ks = *ks + 1;
        if ([*idif numberAtIndex:*ks] == [imax numberAtIndex:*ks])
        {
            goto goto10;
        }
    }

    goto20:
    if ([*idif numberAtIndex:*k] > 0 && *k > *ks)
    {
        [*idif setNumber:[*idif numberAtIndex:*k] - 1 atIndex:*k];
        goto30:
        *k = *k - 1;
        if ([imax numberAtIndex:*k] == 0)
        {
            goto goto30;
        }
        m = *k;
        goto40:
        if ([*idif numberAtIndex:m] >= [imax numberAtIndex:m])
        {
            m--;
            goto goto40;
        }
        [*idif setNumber:[*idif numberAtIndex:m] + 1 atIndex:m];

        if (m == *ks)
        {
            if ([*idif numberAtIndex:m] == [imax numberAtIndex:m])
            {
                *ks = *k;
            }
        }
    }
    else
    {
        goto50:
        for (k1 = *k + 1; k1 <= nrow; k1++)
        {
            if ([*idif numberAtIndex:k1] > 0)
            {
                goto goto70;
            }
        }
        *iflag = 1;
        return;

        goto70:
        mm = 1;
        for (int i = 1; i <= *k; i++)
        {
            mm = mm + [*idif numberAtIndex:i];
            [*idif setNumber:0 atIndex:i];
        }
        *k = k1;
        goto90:
        *k = *k - 1;
        m = MIN(mm, [imax numberAtIndex:*k]);
        [*idif setNumber:m atIndex:*k];
        mm = mm - m;
        if (mm > 0 && *k != 1)
        {
            goto goto90;
        }

        if (mm > 0)
        {
            if (k1 != nrow)
            {
                *k = k1;
                goto goto50;
            }
            *iflag = 1;
            return;
        }

        [*idif setNumber:[*idif numberAtIndex:k1] - 1 atIndex:k1];
        *ks = 0;
        goto100:
        *ks = *ks + 1;
        if (*ks > *k)
        {
            return;
        }
        if ([*idif numberAtIndex:*ks] >= [imax numberAtIndex:*ks])
        {
            goto goto100;
        }
    }
}

+ (void)f8xact:(EIIntArray*)irow and:(int)irowoffset and:(int)iz and:(int)i1 and:(int)izero and:(EIIntArray**)noo and:(int)noooffset
{
    int i = 0;
    for (i = 1; i <= i1 - 1; i++)
    {
        [*noo setNumber:[irow numberAtIndex:i + irowoffset - 1] atIndex:i + noooffset - 1];
    }
    for (i = i1; i <= izero - 1; i++)
    {
        if (iz >= [irow numberAtIndex:i + irowoffset - 1 + 1])
        {
            goto goto30;
        }
        [*noo setNumber:[irow numberAtIndex:i + irowoffset - 1 + 1] atIndex:i + noooffset - 1];
    }

    i = izero;

    goto30:
    [*noo setNumber:iz atIndex:i + noooffset - 1];
    goto40:
    i++;
    if (i > izero)
    {
        return;
    }
    [*noo setNumber:[irow numberAtIndex:i + irowoffset - 1] atIndex:i + noooffset - 1];
    goto goto40;
}

+ (double)f9xact:(int)n and:(int)mm and:(EIIntArray *)ir and:(int)iroffset and:(EIDoubleArray *)fact
{
    double f9xact = [fact numberAtIndex:mm];
    for (int k = 1; k <= n; k++)
    {
        f9xact = f9xact - [fact numberAtIndex:[ir numberAtIndex:k + iroffset - 1]];
    }
    return f9xact;
}

+ (void)f10act:(int)nrow and:(EIIntArray*)irow and:(int)irowoffset and:(int)ncol and:(EIIntArray*)icol and:(int)icoloffset and:(double*)val and:(BOOL*)xmin and:(EIDoubleArray*)fact and:(EIIntArray*)nd and:(EIIntArray*)ne and:(EIIntArray*)m
{
    for (int i = 1; i <= nrow-1; i++)
    {
        [nd setNumber:0 atIndex:i];
    }
    int iz = [icol numberAtIndex:1 + icoloffset - 1] / nrow;
    [ne setNumber:iz atIndex:1];
    int ix = [icol numberAtIndex:1 + icoloffset - 1] - nrow * iz;
    [m setNumber:ix atIndex:1];
    if (ix != 0)
    {
        [nd setNumber:[nd numberAtIndex:ix] + 1 atIndex:ix];
    }

    for (int i = 2; i <= ncol; i++)
    {
        ix = [icol numberAtIndex:i + icoloffset - 1] / nrow;
        [ne setNumber:ix atIndex:i];
        iz = iz + ix;
        ix = [icol numberAtIndex:i + icoloffset - 1] - nrow * ix;
        [m setNumber:ix atIndex:i];
        if (ix != 0)
        {
            [nd setNumber:[nd numberAtIndex:ix] + 1 atIndex:ix];
        }
    }

    for (int i = nrow - 2; i >= 1; i--)
    {
        [nd setNumber:[nd numberAtIndex:i] + [nd numberAtIndex:i + 1] atIndex:i];
    }

    ix = 0;
    int nrw1 = nrow + 1;
    for (int i = nrow; i >= 2; i--)
    {
        ix = ix + iz + [nd numberAtIndex:nrw1 - i] - [irow numberAtIndex:i + irowoffset - 1];
        if (ix < 0)
        {
            return;
        }
    }

    for (int i = 1; i <= ncol; i++)
    {
        ix = [ne numberAtIndex:i];
        iz = [m numberAtIndex:i];
        *val = *val + iz * [fact numberAtIndex:ix + 1] + (nrow - iz) * [fact numberAtIndex:ix];
    }
    *xmin = YES;
}

+ (void)f11act:(EIIntArray*)irow and:(int)irowoffset and:(int)i1 and:(int)i2 and:(EIIntArray*)noo and:(int)noooffset
{
    for (int i = 1; i <= i1 - 1; i++)
    {
        [noo setNumber:[irow numberAtIndex:i + irowoffset - 1] atIndex:i + noooffset - 1];
    }
    for (int i = i1; i <= i2; i++)
    {
        [noo setNumber:[irow numberAtIndex:i + irowoffset - 1 + 1] atIndex:i + noooffset - 1];
    }
}

+ (double)gamds:(double)y and:(double)p and:(int)ifault
{
    double gammds = 0.0;
    int ifail = 1;
    double e = 1.0e-6;
    double zero = 0.0;
    double one = 1.0;

    ifault = 1;
    gammds = zero;

    if (y <= 0 || p <= 0)
        return gammds;

    ifault = 2;
    double f = exp(p * log(y) - [self alogam:p + one and:ifail] - y);
    if (f == zero)
        return gammds;
    ifault = 0;
    double c = one;
    gammds = one;
    double a = p;
    goto10:
    a = a + one;
    c = c * y / a;
    gammds = gammds + c;
    if (c / gammds > e)
        goto goto10;
    gammds = gammds * f;
    return gammds;
}

+ (double)alogam:(double)x and:(int)ifault
{
    double alogam = 0.0;

    double a1 = 0.918938533204673;
    double a2 = 0.00595238095238;
    double a3 = 0.00793650793651;
    double a4 = 0.002777777777778;
    double a5 = 0.08333333333333;

    double half = 0.5;
    double zero = 0.0;
    double one = 1.0;
    double seven = 7.0;

    alogam = zero;
    ifault = 1;
    if (x < zero)
        return alogam;
    ifault = 0;
    double y = x;
    double f = zero;
    if (y > seven)
        goto goto30;
    f = y;
goto10:;
    y = y + one;
    if (y >= seven)
        goto goto20;
    f = f * y;
    goto goto10;
goto20:;
    f = -1.0 * log(f);
goto30:;
    double z = one / (y * y);
    alogam = f + (y - half) * log(y) - y + a1 + (((-a2 * z + a3) * z - a4) * z + a5) / y;

    return alogam;
}

+ (int)maxTableCell:(int)nrow and:(int)ncol and:(NSArray *)table
{
    int maxTableCell = 0;
    for (int r = 0; r < nrow; r++)
        for (int c = 0; c < ncol; c++)
            if ([[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue] > maxTableCell)
                maxTableCell = [[(NSArray *)[table objectAtIndex:r] objectAtIndex:c] intValue];
    return maxTableCell;
}

// Example of pass int by reference
// pass by reference
// pass primitive by reference
+ (int)iwork:(int)iwkmax with:(int*)iwkpt and:(int)number and:(int)itype
{
    int iwork = *iwkpt;
    
    if (itype == 2 || itype == 3)
    {
        *iwkpt = *iwkpt + number;
    }
    else
    {
        if (iwork % 2 != 0)
        {
            iwork = iwork + 1;
        }
        *iwkpt = *iwkpt + 2 * number;
        iwork = iwork / 2;
    }
    
    return iwork;
}

+ (NSArray *)transposeMatrix:(NSArray *)matrix
{
    int c = (int)[(NSArray *)[matrix objectAtIndex:0] count];
    int r = (int)[matrix count];
    
    NSMutableArray *mtx = [[NSMutableArray alloc] init];
    for (int j = 0; j < c; j++)
    {
        NSMutableArray *nsma0 = [[NSMutableArray alloc] init];
        for (int i = 0; i < r; i++)
        {
            NSArray *nsa = [matrix objectAtIndex:i];
            int cellvalue = [(NSNumber *)[nsa objectAtIndex:j] intValue];
            [nsma0 addObject:[NSNumber numberWithInt:cellvalue]];
        }
        [mtx addObject:[NSArray arrayWithArray:nsma0]];
    }
    
    return [NSArray arrayWithArray:mtx];
}

+ (NSMutableArray *)mutableArrayOfInts:(int)capacity
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0; i < capacity; i++)
        [nsma addObject:[NSNumber numberWithInt:0]];
    return nsma;
}
+ (NSMutableArray *)mutableArrayOfDoubles:(int)capacity
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    for (int i = 0; i < capacity; i++)
        [nsma addObject:[NSNumber numberWithDouble:0.0]];
    return nsma;
}
@end
