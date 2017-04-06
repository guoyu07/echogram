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

public class Echogram : Gtk.Window {
	public SonarLog sonar_log;

	public Container cont;

	public Echogram() {
		this.title = "echogram";
		this.destroy.connect(Gtk.main_quit);

		var file = File.new_for_path("test.sl2");

		if (!file.query_exists()) {
			stderr.printf("File '%s' doesn't exist.\n", file.get_path());
		}

		sonar_log = new SonarLog(file);

		sonar_log.header.read();
		if (!sonar_log.header.valid) {
			stderr.printf("File '%s' unknown format.\n", file.get_path());
		}

		sonar_log.index.read();

		cont = new Container(sonar_log);

		this.add(cont);
	}

	protected override bool key_press_event (Gdk.EventKey event) {
		var key = Gdk.keyval_name(event.keyval);
		if (key == "Right") {
			cont.forward(50);
		}

		if (key == "Left") {
			cont.backward(50);
		}

		stdout.printf("|%s|\n", key);
		return true;
	}

	public static int main(string[] args) {
		Gtk.init(ref args);

		var window = new Echogram();
		window.show_all();

		Gtk.main();

		return 0;
	}
}

