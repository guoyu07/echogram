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

public class Ping : Object {
	public uint16 block_size;
	public uint16 last_block_size;
	public Channel channel;
	public uint16 packet_size;
	public uint32 frame_index;
	public float upper_limit;
	public float lower_limit;
	public Frequency frequency;
	public float water_depth;
	public float keel_depth;
	public float speed;
	public float water_temp;
	public float longitude;
	public float latitude;
	public float water_speed;
	public float course;
	public float altitude;
	public float heading;
	public uint16 validate;
	public uint32 timestamp;
	public uint8[] packet;

	public Ping(DataInputStream data_stream, Index index,
				Channel channel, int position) throws IOError, Error {
		var offset = index.map[channel][position];
		data_stream.seek(offset, SeekType.SET);

		data_stream.skip(28);
		block_size = data_stream.read_uint16();
		last_block_size = data_stream.read_uint16();
		channel = (Channel)data_stream.read_uint16();
		packet_size = data_stream.read_uint16();
		frame_index = data_stream.read_uint32();
		upper_limit = feet_to_meters(read_float(data_stream));
		lower_limit = feet_to_meters(read_float(data_stream));
		data_stream.skip(5);
		frequency = (Frequency)data_stream.read_byte();
		data_stream.skip(6);
		water_depth = read_float(data_stream);
		data_stream.skip(8);
		keel_depth = read_float(data_stream);
		data_stream.skip(24);
		speed = read_float(data_stream);
		water_temp = read_float(data_stream);
		longitude = read_float(data_stream);
		latitude = read_float(data_stream);
		water_speed = read_float(data_stream);
		course = read_float(data_stream);
		altitude = read_float(data_stream);
		heading = read_float(data_stream);
		validate = data_stream.read_uint16();
		data_stream.skip(6);
		timestamp = data_stream.read_uint32();
		packet = new uint8[packet_size];
		data_stream.read(packet);
	}

	private float read_float (InputStream stream) throws Error {
		uint8 buffer[4];

		stream.read_all (buffer, null, null);
		float[] fbuffer = (float[]) buffer;

		return fbuffer[0];
	}
}
