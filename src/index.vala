/*
 *  This file is part of Echogram, a Gtk+ echogram viewer application.
 *  Copyright (C) 2016 Igor Goryachev <igor@goryachev.org>
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

public class Index : Object {
	private DataInputStream data_stream;

	private int64 file_size;

	public Gee.HashMap<Channel, Gee.ArrayList<int64?>> map;

	public Index(DataInputStream data_stream, int64 file_size) {
		this.data_stream = data_stream;

		this.file_size = file_size;

		map = new Gee.HashMap<Channel, Gee.ArrayList<int64?>>();
	}

	public void read() throws IOError, Error {
		while (true) {
			int64 offset = data_stream.tell();

			if (offset == file_size) {
				break;
			}

			data_stream.skip(28);

			uint16 block_size = data_stream.read_uint16();

			data_stream.skip(2);

			Channel channel = (Channel)data_stream.read_uint16();

			data_stream.seek(offset + block_size, SeekType.SET);

			if (map.get(channel) == null) {
				map[channel] = new Gee.ArrayList<int64?>();
			}
			map[channel].add(offset);
		}
	}

	public int size(Channel channel) {
		return map[channel].size;
	}
}
