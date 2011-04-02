/* frame.m
 *
 * Copyright (c) 2002-2011 Apple Inc. All Rights Reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "frame.h"
#include "quartz-wm.h"
#include <X11/extensions/applewm.h>

int
frame_titlebar_height (xp_frame_class class)
{
    short x, y, w, h;

    XAppleWMFrameGetRect (x_dpy, class, XP_FRAME_RECT_TITLEBAR,
                          0, 0, 0, 0, 0, 0, 0, 0, &x, &y, &w, &h);

    return h;
}

void
draw_frame (int screen, Window id, X11Rect outer_r, X11Rect inner_r,
            xp_frame_class class, xp_frame_attr attr, CFStringRef title)
{
    unsigned char title_bytes[512];
    CFIndex title_length;

    if (title == NULL)
        title_length = 0;
    else
    {
        /* FIXME: kind of lame */
        CFStringGetBytes (title, CFRangeMake (0, CFStringGetLength (title)),
                          kCFStringEncodingUTF8, 0,
                          FALSE, title_bytes,
                          sizeof (title_bytes),
                          &title_length);
    }

    XAppleWMFrameDraw (x_dpy, screen, id, class, attr,
                       inner_r.x, inner_r.y,
                       inner_r.width, inner_r.height,
                       outer_r.x, outer_r.y,
                       outer_r.width, outer_r.height,
                       title_length, title_bytes);
}

X11Rect
frame_tracking_rect (X11Rect outer_r, X11Rect inner_r, xp_frame_class class)
{
    short x, y, w, h;

    XAppleWMFrameGetRect (x_dpy, class, XP_FRAME_RECT_TRACKING,
                          inner_r.x, inner_r.y,
                          inner_r.width, inner_r.height,
                          outer_r.x, outer_r.y,
                          outer_r.width, outer_r.height,
                          &x, &y, &w, &h);

    return X11RectMake (x, y, w, h);
}

X11Rect
frame_growbox_rect (X11Rect outer_r, X11Rect inner_r, xp_frame_class class)
{
    short x, y, w, h;

    XAppleWMFrameGetRect (x_dpy, class, XP_FRAME_RECT_GROWBOX,
                          inner_r.x, inner_r.y,
                          inner_r.width, inner_r.height,
                          outer_r.x, outer_r.y,
                          outer_r.width, outer_r.height,
                          &x, &y, &w, &h);

    return X11RectMake (x, y, w, h);
}

unsigned int
frame_hit_test (X11Rect outer_r, X11Rect inner_r, unsigned int class, X11Point p)
{
    return XAppleWMFrameHitTest (x_dpy, class, p.x, p.y,
                                 inner_r.x, inner_r.y,
                                 inner_r.width, inner_r.height,
                                 outer_r.x, outer_r.y,
                                 outer_r.width, outer_r.height);
}
