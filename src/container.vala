/*
 *  This file is part of Echogram, a Gtk+ echogram viewer application.
 *
 *  Copyright (C) 2017 Igor Goryachev <igor@goryachev.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

public class Container : Gtk.Container {
	private Gtk.Widget _child;

	public Gtk.Paned pv;
	public Gtk.Paned ph;

	public View v1;
	public View v2;
	public View v3;

	public Container (SonarLog sonar_log) {
		base.set_has_window (false);
        base.set_can_focus (true);
        base.set_redraw_on_allocate (false);

		this._child = null;

		pv = new Gtk.Paned (Gtk.Orientation.VERTICAL);
		// pv.set_wide_handle (true);

		ph = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
		// ph.set_wide_handle (true);

		pv.add1(ph);

		v1 = new View(sonar_log, Channel.PRIMARY, Orientation.HORIZONTAL);
		v2 = new View(sonar_log, Channel.DOWNSCAN, Orientation.HORIZONTAL);
		v3 = new View(sonar_log, Channel.SIDESCAN, Orientation.VERTICAL);

		// ph.add1(v1);
		// ph.add2(v2);
		// pv.add2(v3);

		ph.pack1 (v1, false, true);
		ph.pack2 (v2, false, true);
		pv.pack2 (v3, false, true);

		// ph.pack1 (v1, true, t);
		// ph.pack2 (v2, true, false);
		// pv.pack2 (v3, true, false);

		pv.notify["position"].connect(position_changed_pv);
		ph.notify["position"].connect(position_changed_ph);

		// pv.notify["size-allocate"].connect(position_changed_pv);
		// ph.notify["size-allocate"].connect(position_changed_ph);

		add (pv);
	}

	public void forward(int inc) throws Error {
		v1.forward(inc);
		v2.forward(inc);
		v3.forward(inc);
	}

	public void backward(int inc) throws Error {
		v1.backward(inc);
		v2.backward(inc);
		v3.backward(inc);
	}

	public void redraw() {
		v1.redraw();
		v2.redraw();
		v3.redraw();
	}

	private void position_changed_pv(GLib.Object paned, ParamSpec spec) {
		var v = pv.get_position();

		v1.height = v;
		v2.height = v;
		v3.height = pv.get_allocated_height() - v;

		redraw();
	}

	private void position_changed_ph(GLib.Object paned, ParamSpec spec) {
		var h = ph.get_position();

		v1.width = h;
		v2.width = ph.get_allocated_width() - h;

		v1.redraw();
		v2.redraw();
	}

	public override void add (Gtk.Widget widget) {
		if (this._child == null) {
			widget.set_parent (this);

			this._child = widget;
		}
	}

	public override void remove (Gtk.Widget widget) {
        if (this._child == widget) {

            widget.unparent ();
            this._child = null;

            if (this.get_visible () && widget.get_visible ()) {
                this.queue_resize_no_redraw ();
            }
        }
    }

	public override void forall_internal (bool include_internals, Gtk.Callback callback) {
        if (this._child != null) {
            callback (this._child);
        }
    }

    public override Gtk.SizeRequestMode get_request_mode () {
        if (this._child != null) {
            return this._child.get_request_mode ();
        } else {
            return Gtk.SizeRequestMode.HEIGHT_FOR_WIDTH;
        }
    }

    public Gtk.Widget get_child () {
        return this._child;
    }

	public override void size_allocate (Gtk.Allocation allocation) {
		if (this._child != null && this._child.get_visible ()) {
			this._child.size_allocate (allocation);
			if (this.get_realized ()) {
				this._child.show ();
			}
		}

		if (this.get_realized ()) {
			if (this._child != null) {
				this._child.set_child_visible (true);
			}
		}

		base.size_allocate (allocation);
	}

	public new void get_preferred_size (out Gtk.Requisition minimum_size,
										out Gtk.Requisition natural_size) {
		Gtk.Requisition child_minimum_size = {0, 0};
        Gtk.Requisition child_natural_size = {0, 0};

		if (this._child != null && this._child.get_visible ()) {
            this._child.get_preferred_size (out child_minimum_size, out child_natural_size);
        }

		minimum_size = {0, 0};
        natural_size = {0, 0};

		minimum_size.width = child_minimum_size.width;
        minimum_size.height = child_minimum_size.height;
        natural_size.width = child_natural_size.width;
        natural_size.height = child_natural_size.height;
	}

	public override void get_preferred_width (out int minimum,
											  out int natural) {
		minimum = 0;
		natural = 0;

		if (this._child != null && this._child.get_visible ()) {
			this._child.get_preferred_width (out minimum, out natural);
		}
	}

	public override void get_preferred_height (out int minimum,
											   out int natural) {
		minimum = 0;
		natural = 0;

		if (this._child != null && this._child.get_visible ()) {
			this._child.get_preferred_height (out minimum, out natural);
		}
	}

	public override bool draw (Cairo.Context cr) {
		base.draw (cr);

		return false;
	}
}
