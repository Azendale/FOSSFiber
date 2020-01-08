# Copyright 2019, 2020 Erik B. Andersen <erik.b.andersen@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Please note that the author of this software considers use (over a network)
# by employees of a business "distribution", triggering the requirements
# to provide source code for modified versions. Publishing a git branch
# in a public location (such as github) is an acceptable way to provide
# source code.
##############################################################################

# Create your models here.

# Begin inspectdb auto generated section:
# MANUALLY EDITED!!!!!
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#	* Rearrange models' order
#	* Make sure each model has one field with primary_key=True
#	* Make sure each ForeignKey has `on_delete` set to the desired behavior.
#	* Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.contrib.gis.db import models
from django.db.models import Q
import functools

indextocolor = ['1basedindexingpad', 'blue', 'orange', 'green', 'brown', 'slate', 'white', 'red', 'black', 'yellow', 'violet', 'rose', 'auqa', 'blue w/ black', 'orange w/ black', 'green w/ black', 'brown w/ black', 'slate w/ black', 'white w/ black', 'red w/ black', 'black w/ white', 'yellow w/ black', 'violet w/ black', 'rose w/ black', 'auqa w/ black']
colortoindex = dict(zip(indextocolor[1:], range(1,25)))

def meters_to_inches(meters):
	return meters/0.0254

def inches_to_meters(inches):
	return inches*0.0254

def inches_to_ftinches(inches):
	return int(inches/12), inches%12

def ftinches_to_inches(feet, inches):
	return (feet*12)+inches

class Address(models.Model):
	address_number = models.IntegerField(blank=True, null=True)
	address_number_fraction = models.TextField(blank=True, null=True)
	street_direction_pre = models.TextField(blank=True, null=True)
	street_name = models.TextField(blank=True, null=True)
	road_type_abbreviation = models.TextField(blank=True, null=True)
	street_direction_post = models.TextField(blank=True, null=True)
	sublocation_label = models.TextField(blank=True, null=True)
	sublocation_identifier = models.TextField(blank=True, null=True)
	city = models.TextField(blank=True, null=True)
	state = models.TextField(blank=True, null=True)
	zip_code = models.IntegerField(blank=True, null=True)
	ext_tb_location_id = models.IntegerField(blank=True, null=True)
	building = models.ForeignKey('Building', models.DO_NOTHING, blank=True, null=True)

	def __repr__(self):
		streetline = ' '.join([ x for x in [str(self.address_number), self.address_number_fraction, self.street_direction_pre, self.street_name, self.road_type_abbreviation, self.street_direction_post] if x])
		sublocline = ' '.join([ x for x in [self.sublocation_label, self.sublocation_identifier] if x])
		return ', '.join([x for x in [streetline, sublocline, self.city, self.state, str(self.zip_code)] if x])

	def __str__(self):
		return self.__repr__()

	def __unicode__(self):
		return self.__repr__()

	class Meta:
		managed = False
		db_table = 'address'


class Building(models.Model):
	building_location = models.GeometryField()

	def __str__(self):
		desc = 'Building object {}'.format(self.id)
		try:
			desc = str(self.addressess.all()[0])
		except:
			pass
		return desc

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'building'


class CableFiberEnd(models.Model):
	fiber = models.ForeignKey('Fiber', models.DO_NOTHING)
	fiber_end = models.ForeignKey('FiberEnd', models.DO_NOTHING, unique=True)
	fiber_cable_segment_end = models.ForeignKey('FiberCableSegmentEnd', models.DO_NOTHING)

	class Meta:
		managed = False
		db_table = 'cable_fiber_end'


class Conduit(models.Model):
	length = models.FloatField(blank=True, null=True)
	conduit_route = models.LineStringField(blank=True, null=True)
	conduit_type = models.ForeignKey('ConduitType', models.DO_NOTHING)
	built = models.DateTimeField(blank=True, null=True)
	underground = models.BooleanField(blank=True, null=True)
	length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, blank=True, null=True)

	class Meta:
		managed = False
		db_table = 'conduit'


class ConduitType(models.Model):
	diameter = models.FloatField(blank=True, null=True)
	diameter_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='diameter_units', blank=True, null=True, related_name='units_as_conduit_diameter')
	length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True, related_name='units_as_conduit_length')
	conduit_type_name = models.TextField()

	def __str__(self):
		return self.conduit_type_name

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'conduit_type'


class ConduitVaultEntryOrEnd(models.Model):
	meterage = models.FloatField(blank=True, null=True)
	f_end = models.BooleanField(blank=True, null=True)
	vault_sequence = models.FloatField(blank=True, null=True)
	underground_vault = models.ForeignKey('UndergroundVault', models.DO_NOTHING, blank=True, null=True)
	conduit = models.ForeignKey(Conduit, models.DO_NOTHING)

	def __str__(self):
		if self.f_end:
			description = 'Conduit {} end'.format(self.conduit)
		elif self.underground_vault:
			description = 'Conduit vault {} entry'.format(self.underground_vault.id)
		if self.meterage:
			if 'ft' == self.conduit.length_units.shortsymbol:
				description += 'at {}'.format(inches_to_ftinches(meters_to_ftinches(self.meterage)))
			else:
				description += 'at {} m'.format(self.meterage)
		return description

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'conduit_vault_entry_or_end'


class EnclosurePort(models.Model):
	fiber_enclosure = models.ForeignKey('FiberEnclosure', models.DO_NOTHING)
	port_label = models.TextField(blank=True, null=True)
	fiber_connection = models.ForeignKey('FiberConnection', models.DO_NOTHING, unique=True)

	def __str__(self):
		return 'port {} on enclosure {}'.format(self.port_label, self.fiber_enclosure)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'enclosure_port'


class EnclosurePortTemplate(models.Model):
	fiber_enclosure_template = models.ForeignKey('FiberEnclosureTemplate', models.DO_NOTHING)
	port_label = models.TextField(blank=True, null=True)
	fiber_connection_template = models.ForeignKey('FiberConnectionEnclosurePortTemplate', models.DO_NOTHING, unique=True)

	def __str__(self):
		return 'port {} on enclosure template {}'.format(self.port_label, self.fiber_enclosure_template)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'enclosure_port_template'


class Fiber(models.Model):
	cable = models.ForeignKey('FiberCable', models.DO_NOTHING)

	def __str__(self):
		id_indexes = sorted(self.fiberidentifierindexs.objects.all(), key=(lambda x: x.group_level))
		index_types = [ x.group_type.indexname for x in sorted(self.cable.fiber_group.objects().all(), key=(lambda x: x.level)) ]
		indexdesc = [ (indextocolor[id_index], indextype) for id_index, indextype in zip(id_indexes, index_types)  ]

		indexstr = ','.join(['{} {}'.format(color, indextype) for color, indextype in indexdesc])

		enddescriptions = []
		for cablefiberend in self.cablefiberends.objects.all():
			enddesc = ''
			fcse = str(cablefiberend.fiber_cable_segment_end)
			if None != fcse.fiber_enclosure:
				enddesc += ' in enclosure {}'.format(str(fcse.fiber_enclosure))
			enddescriptions.append(enddesc)
		if len(enddescriptions) == 2:
			return '{} fiber in cable #{} from {} to {}'.format(indexstr, self.cable.id, enddescriptions[0], enddescriptions[1])
		elif len(enddescriptions) == 1:
			return '{} fiber in cable #{} with end {}'.format(indexstr, self.cable.id, enddescriptions[0])
		else:
			return '{} fiber in cable #{}'.format(indexstr, self.cable.id)

	def __repr__(self):
		return self.__dict__


	class Meta:
		managed = False
		db_table = 'fiber'


class FiberCable(models.Model):
	cable_start_length_measure = models.FloatField(blank=True, null=True)
	cable_end_length_measure = models.FloatField(blank=True, null=True)
	length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True)
	fiber_groups_depth = models.SmallIntegerField(blank=True, null=True)
	f_armored = models.BooleanField(blank=True, null=True)
	f_outdoor = models.BooleanField(blank=True, null=True)
	fiber_groups_top_level_count = models.SmallIntegerField(blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)

	def __str__(self):
		outdoor_str = ''
		armored_str = ''
		if self.f_outdoor:
			outdoor_str = ' outdoor'
		if self.f_armored:
			outdoor_str = ' armored'
		cable_type = ''
		subgroup_counts = [self.fiber_groups_top_level_count]
		subgroup_counts.extend([ x.subgroup_count for x in self.fibergroups_set.all() ])
		try:
			group_typename = ' ' + sorted(self.fiber_groups.objects.all(), key=(lambda x: x.level))[0].group_type.indexname
		except IndexError:
			group_typename = ''
		count = functools.reduce((lambda x, y: x*y), subgroup_counts)
		return '{} count{}{}{} cable'.format(count, outdoorstr, armored_str)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable'


class FiberCableSegment(models.Model):
	fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)

	def __str__(self):
		a_marking_translated = 'unkown'
		b_marking_translated = 'unkown'
		ends = self.fibercablesegmentend.all()
		try:
			a_marking_translated = '{}m'.format(ends[0].cable_meterage)
			b_marking_translated = '{}m'.format(ends[1].cable_meterage)
		except IndexError:
			pass
		if 'feet' == self.fiber_cable_segment.fiber_cable.length_units.unit_name:
			try:
				a_marking_translated = inches_to_ftinches(meters_to_inches(ends[0].cable_meterage))
				b_marking_translated = inches_to_ftinches(meters_to_inches(ends[1].cable_meterage))
			except IndexError:
				pass

		return 'cable {} segment {} at {}{}{}'.format(self.fiber_cable.id, self.id, a_marking_translated, b_marking_translated)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable_segment'


class FiberCableSegmentEnd(models.Model):
	fiber_cable_segment = models.ForeignKey(FiberCableSegment, models.DO_NOTHING)
	start_end = models.BooleanField(blank=True, null=True)
	cable_meterage = models.FloatField(blank=True, null=True)
	cable_sort = models.FloatField(blank=True, null=True)
	tape_marking = models.TextField(blank=True, null=True)
	label = models.TextField(blank=True, null=True)
	fiber_enclosure = models.ForeignKey('FiberEnclosure', models.DO_NOTHING, blank=True, null=True)

	def __str__(self):
		marking_translated = '{}m'.format(self.in_meterage)
		if 'feet' == self.fiber_cable_segment.fiber_cable.length_units.unit_name:
			marking_translated = inches_to_ftinches(meters_to_inches(self.cable_meterage))
		label_str = ''
		tape_str = ''
		if None != self.tape_marking:
			tape_str = ' with tape marking {}'.format(self.tape_marking)
		if None != self.label:
			label_str = ' with label {}'.format(self.label)
		return 'cable {} segment {} at {}{}{}'.format(self.fiber_cable.id, marking_translated, tape_str, label_str)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable_segment_end'


class FiberCableSlackCoil(models.Model):
	fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)
	in_meterage = models.FloatField(blank=True, null=True)
	latlong_root = models.PointField(geography=True, blank=True, null=True)
	latlong_free_end = models.PointField(geography=True, blank=True, null=True)
	out_meterage = models.FloatField(blank=True, null=True)
	cable_sort = models.FloatField(blank=True, null=True)

	def __str__(self):
		in_marking_translated = '{}m'.format(self.in_meterage)
		out_marking_translated = '{}.m'.format(self.out_meterage)
		if 'feet' == self.fiber_cable.length_units.unit_name:
			in_marking_translated = inches_to_ftinches(meters_to_inches(self.in_meterage))
			out_marking_translated = inches_to_ftinches(meters_to_inches(self.out_meterage))
		return 'cable {} slack coil from {} to {}'.format(self.fiber_cable.id, in_marking_translated, out_marking_translated)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable_slack_coil'


class FiberCableSlackCoilLocatedInUndergroundVault(models.Model):
	underground_vault = models.ForeignKey('UndergroundVault', models.DO_NOTHING)
	fiber_cable_slack_loop = models.ForeignKey(FiberCableSlackCoil, models.DO_NOTHING)

	def __str__(self):
		return '{} in vault id {}'.format(self.fiber_cable_slack_loop, self.underground_vault.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable_slack_coil_located_in_underground_vault'


class FiberCableTemplate(models.Model):
	length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True)
	fiber_groups_depth = models.SmallIntegerField(blank=True, null=True)
	f_armored = models.BooleanField(blank=True, null=True)
	f_outdoor = models.BooleanField(blank=True, null=True)
	fiber_groups_top_level_count = models.SmallIntegerField(blank=True, null=True)
	template_name = models.TextField()

	def __str__(self):
		outdoor_str = ''
		armored_str = ''
		if self.f_outdoor:
			outdoor_str = ' (outdoor)'
		if self.f_armored:
			outdoor_str = ' (armored)'
		cable_type = ''
		subgroup_counts = [self.fiber_groups_top_level_count]
		for i in range(0, self.fiber_groups_depth+1):
			group_template = self.fibergrouptemplates.filter(Q(level=i))[0]
			subgroup_count.append(group_template.subgroup_count)
			group_typename = group_template.group_type.shortname
			if i == self.fiber_groups_depth:
				if 'ribbon' == group_typename:
					cable_type == 'ribbon '
				elif 'buffer tube' ==  group_typename:
					cable_type == 'loose tube '
		count = functools.reduce((lambda x, y: x*y), subgroup_counts)
		return '{}: {} count {}cable{}{}'.format(self.template_name, count, outdoorstr, armored_str)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_cable_template'


class FiberConnection(models.Model):
	connected_fiber_end_a = models.ForeignKey('FiberEnd', models.DO_NOTHING, blank=True, null=True, related_name='fiber_end_as_side_a')
	connected_fiber_end_b = models.ForeignKey('FiberEnd', models.DO_NOTHING, blank=True, null=True, related_name='fiber_end_as_side_b')
	a_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='optical_connector_type_as_side_a')
	b_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='optical_connector_type_as_side_b')
	built = models.DateTimeField(blank=True, null=True)

	def __str__(self):
		#TODO: show extra details of inheriting class based off entries in the fiber_connection_meta_instance_inheritance
		if False == self.built:
			return 'planned fiber connection {}, between FE {} & FE {}'.format(self.id, self.connected_fiber_end_a.id, self.connected_fiber_end_b.id)
		else:
			return 'planned fiber connection {}, between FE {} & FE {}'.format(self.id, self.connected_fiber_end_a.id, self.connected_fiber_end_b.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_connection'


class FiberConnectionEnclosurePortTemplate(models.Model):
	a_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='optical_connector_type_as_enclosure_template_a')
	b_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='optical_connector_type_as_enclosure_template_b')

	def __str__(self):
		return 'Enclosure template {} port template {}: {}x{}'.format(planned_str, self.id, self.a_optical_connector_type, self.b_optical_connector_type)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_connection_enclosure_port_template'


class FiberConnectionMetaInstanceInheritance(models.Model):
	fiber_connection = models.ForeignKey(FiberConnection, models.DO_NOTHING, primary_key=True)
	inheriting_table_name = models.TextField()
	inheriting_table_fk_column_name = models.TextField()

	class Meta:
		managed = False
		db_table = 'fiber_connection_meta_instance_inheritance'
		unique_together = (('fiber_connection', 'inheriting_table_name', 'inheriting_table_fk_column_name'),)


class FiberEnclosure(models.Model):
	longlat = models.PointField(geography=True, blank=True, null=True)
	manufacturer_name = models.TextField(blank=True, null=True)
	enclosure_model = models.TextField(blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)

	def __str__(self):
		if False == self.built:
			planned_str = 'planned '
		else:
			planned_str = ''
		return '{}fiber enclosure id {}: {} {}'.format(planned_str, self.id, self.manufacterer_name, self.enclosure_model)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_enclosure'


class FiberEnclosureCoverage(models.Model):
	coverage_area = models.PolygonField()
	fiber_enclosure = models.ForeignKey(FiberEnclosure, models.DO_NOTHING)

	def __str__(self):
		return 'fiber enclosure id {} coverage'.format(self.fiber_enclosure.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_enclosure_coverage'


class FiberEnclosureLocatedInUndergroundVault(models.Model):
	fiber_enclosure = models.ForeignKey(FiberEnclosure, models.DO_NOTHING)
	underground_vault = models.ForeignKey('UndergroundVault', models.DO_NOTHING)

	def __str__(self):
		return 'fiber enclosure id {} in vault id {}'.format(self.fiber_enclosure.id, self.underground_vault.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_enclosure_located_in_underground_vault'


class FiberEnclosureTemplate(models.Model):
	manufacturer_name = models.TextField(blank=True, null=True)
	enclosure_model = models.TextField(blank=True, null=True)
	template_name = models.TextField()

	def __str__(self):
		return '{}: {} {}'.format(self.template_name, self.manufacterer_name, self.enclosure_model)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_enclosure_template'


class FiberEnd(models.Model):
	optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True)

	def __str__(self):
		# TODO: check fiber_end_meta_instance_inheritance and show extra data based on type
		if None != self.optical_connector_type:
			return 'Fiber end id # {}, connector type {}'.format(self.id, self.optical_connector_type)
		else:
			return 'Fiber end id # {}'.format(self.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_end'


class FiberEndMetaInstanceInheritance(models.Model):
	fiber_end = models.ForeignKey(FiberEnd, models.DO_NOTHING, primary_key=True)
	inheriting_table_name = models.TextField()
	inheriting_table_fk_column_name = models.TextField()

	class Meta:
		managed = False
		db_table = 'fiber_end_meta_instance_inheritance'
		unique_together = (('fiber_end', 'inheriting_table_name', 'inheriting_table_fk_column_name'),)


class FiberGroup(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	subgroup_count = models.SmallIntegerField(blank=True, null=True)
	group_type = models.ForeignKey('FiberGroupTypes', models.DO_NOTHING)
	level = models.SmallIntegerField(blank=True, null=True)
	fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)

	def __str__(self):
		return 'fiber cable {} subgroup level {}, type "{}", {} children'.format(self.fiber_cable.id, self.group_level, self.group_type.shortname, self.subgroup_count)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_group'


class FiberGroupTemplate(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	subgroup_count = models.SmallIntegerField(blank=True, null=True)
	group_type = models.ForeignKey('FiberGroupTypes', models.DO_NOTHING)
	level = models.SmallIntegerField(blank=True, null=True)
	fiber_cable_template = models.ForeignKey(FiberCableTemplate, models.DO_NOTHING)

	def __str__(self):
		return 'fiber cable template {} subgroup template level {}, type "{}", {} children'.format(self.fiber_cable_template.id, self.group_level, self.group_type.shortname, self.subgroup_count)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_group_template'


class FiberGroupTypes(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	shortname = models.TextField(blank=True, null=True)

	def __str__(self):
		return self.shortname

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_group_types'


class FiberIdentifierIndex(models.Model):
	group_index = models.SmallIntegerField(blank=True, null=True)
	group_level = models.SmallIntegerField(blank=True, null=True)
	fiber = models.ForeignKey(Fiber, models.DO_NOTHING)

	def __str__(self):
		try:
			group_type_name = self.fiber.cable.fibergroups.filter(Q(level=self.group_level)).group_type.shortname
		except:
			group_type_name = '<level {} group type>'.format(self.group_level)
		color = indextocolor[self.group_index]
		return '{} {} in fiber cable {}, fiber id {}'.format(color, group_type_name, self.fiber.cable.id, self.fiber.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_identifier_index'


class FiberSplice(models.Model):
	fiber_connection = models.ForeignKey(FiberConnection, models.DO_NOTHING, unique=True)
	fusion = models.BooleanField(blank=True, null=True)
	estimated_loss = models.FloatField(blank=True, null=True)

	def __str__(self):
		planned_str = ''
		fusion_str = ''
		if False == self.fiber_connection.built:
			planned_str = 'planned '
		if self.fusion:
			fusion_str = 'fusion '

		return '{}{}splice {}, fiber connection {}, between FE {} & FE {}'.format(planned_str, fusion_str, self.id, self.fiber_connection.id, self.fiber_connection.connected_fiber_end_a.id, self.fiber_connection.connected_fiber_end_b.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'fiber_splice'


class HistoryBool(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.BooleanField(blank=True, null=True)
	after_value = models.BooleanField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_bool'


class HistoryBoolDeletion(models.Model):
	history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.BooleanField(blank=True, null=True)

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}, previous value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_bool_deletion'


class HistoryGeometryLinestring(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.LineStringField(blank=True, null=True)
	after_value = models.LineStringField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_geometry_linestring'


class HistoryGeometryLinestringDeletion(models.Model):
	history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.LineStringField(blank=True, null=True)

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}, previous value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_geometry_linestring_deletion'


class HistoryGeometryPoint(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.PointField(blank=True, null=True)
	after_value = models.PointField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_geometry_point'


class HistoryGeometryPointDeletion(models.Model):
	history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.PointField(blank=True, null=True)

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}, previous value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_geometry_point_deletion'


class HistoryInteger(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.IntegerField(blank=True, null=True)
	after_value = models.IntegerField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_integer'


class HistoryIntegerDeletion(models.Model):
	history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.IntegerField(blank=True, null=True)

	class Meta:
		managed = False
		db_table = 'history_integer_deletion'


class HistoryReal(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.FloatField(blank=True, null=True)
	after_value = models.FloatField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_real'


class HistoryRealDeletion(models.Model):
	history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.FloatField(blank=True, null=True)

	class Meta:
		managed = False
		db_table = 'history_real_deletion'


class HistoryRowCreation(models.Model):
	table_name = models.TextField()
	table_id = models.IntegerField()
	username = models.TextField(blank=True, null=True)
	creation = models.DateTimeField()

	def __str__(self):
		return 'Creation: Table {}, id {}, column {}, by {} at {}'.format(self.table_name, self.table_id, self.username, self.creation)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_row_creation'


class HistoryRowDeletion(models.Model):
	table_name = models.TextField()
	table_row_id = models.IntegerField()
	username = models.TextField(blank=True, null=True)
	deletion = models.DateTimeField()

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}'.format(self.table_name, self.table_row_id, self.username, self.deletion)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_row_deletion'


class HistorySmallint(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.SmallIntegerField(blank=True, null=True)
	after_value = models.SmallIntegerField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_smallint'


class HistorySmallintDeletion(models.Model):
	history_row_deletion = models.ForeignKey(HistoryRowDeletion, models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.SmallIntegerField(blank=True, null=True)

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}, previous value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_smallint_deletion'


class HistoryText(models.Model):
	table_name = models.TextField()
	column_name = models.TextField()
	change_date = models.DateTimeField()
	username = models.TextField(blank=True, null=True)
	before_value = models.TextField(blank=True, null=True)
	after_value = models.TextField(blank=True, null=True)

	def __str__(self):
		return 'Change: Table {}, id {}, column {}, by {} at {}, previous value {}, new value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value, self.after_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_text'


class HistoryTextDeletion(models.Model):
	history_row_deletion = models.ForeignKey(HistoryRowDeletion, models.DO_NOTHING)
	column_name = models.TextField()
	before_value = models.TextField(blank=True, null=True)

	def __str__(self):
		return 'Deletion: Table {}, id {}, column {}, by {} at {}, previous value {}'.format(self.history_row_deletion.table_name, self.history_row_deletion.table_row_id, self.column_name, self.history_row_deletion.username, self.history_row_deletion.deletion, self.before_value)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'history_text_deletion'


class LengthUnits(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	unit_name = models.TextField()
	unit_shortsymbol = models.TextField()

	def __str__(self):
		return self.unit_name

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'length_units'



class LoadSupportAttachment(models.Model):
	load_linear_sequence = models.FloatField(blank=True, null=True)
	type_load = models.SmallIntegerField()
	type_support = models.SmallIntegerField()
	linear_reverse = models.BooleanField(blank=True, null=True)
	fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING, blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)
	supporting_building = models.ForeignKey(Building, models.DO_NOTHING, blank=True, null=True)
	support_conduit = models.ForeignKey(Conduit, models.DO_NOTHING, blank=True, null=True, related_name='conduit_as_lsa_support')
	load_conduit = models.ForeignKey(Conduit, models.DO_NOTHING, blank=True, null=True, related_name='conduit_as_lsa_load')
	support_strand_line = models.ForeignKey('StrandLine', models.DO_NOTHING, blank=True, null=True, related_name='strand_as_lsa_support')
	load_strand_line = models.ForeignKey('StrandLine', models.DO_NOTHING, blank=True, null=True, related_name='strand_as_lsa_load')

	class Meta:
		managed = False
		db_table = 'load_support_attachment'


class LoadSupportAttachmentPoint(models.Model):
	linear_sequence = models.FloatField(blank=True, null=True)
	latlong_cached = models.PointField(blank=True, null=True)
	load_meterage = models.FloatField(blank=True, null=True)
	load_sort = models.FloatField(blank=True, null=True)
	pole_attachment = models.ForeignKey('PoleAttachment', models.DO_NOTHING, blank=True, null=True)
	underlying_load_support_attachment_point_id = models.IntegerField(blank=True, null=True)
	load_support_attachment = models.ForeignKey(LoadSupportAttachment, models.DO_NOTHING)

	class Meta:
		managed = False
		db_table = 'load_support_attachment_point'


class MapBookmark(models.Model):
	map_center = models.PointField()
	zoom_level = models.IntegerField(blank=True, null=True)
	bookmark_name = models.TextField()

	def __str__(self):
		return 'Bookmark {}'.format(self.bookmark_name)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'map_bookmark'


class OpticalConnectorTypes(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	name = models.TextField()
	gender = models.CharField(max_length=1, blank=True, null=True)

	def __str__(self):
		if gender:
			return 'Connector type {}({})'.format(self.name, self.gender.lower())
		else:
			return 'Connector type {}'.format(self.name)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_connector_types'


class OpticalSplitter(models.Model):
	inputs_count = models.SmallIntegerField()
	outputs_count = models.SmallIntegerField(blank=True, null=True)
	splitter_type = models.ForeignKey('OpticalSplitterTypes', models.DO_NOTHING, blank=True, null=True)
	splitter_style = models.ForeignKey('OpticalSplitterStyles', models.DO_NOTHING, blank=True, null=True)
	containing_fiber_enclosure = models.ForeignKey(FiberEnclosure, models.DO_NOTHING, db_column='containing_fiber_enclosure', blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)

	def __str__(self):
		if built:
			return 'Splitter {}: {}x{} {} {}'.format(self.id, str(self.inputs_count), str(self.outputs_count), self.splitter_type.type_label, self.splitter_style.style_label)
		else:
			return 'Planned splitter {}: {}x{} {} {}'.format(self.id, str(self.inputs_count), str(self.outputs_count), self.splitter_type.type_label, self.splitter_style.style_label)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter'


class OpticalSplitterInput(models.Model):
	power_drop = models.FloatField(blank=True, null=True)
	input_label = models.TextField(blank=True, null=True)
	optical_splitter = models.ForeignKey(OpticalSplitter, models.DO_NOTHING)
	fiber_end = models.ForeignKey(FiberEnd, models.DO_NOTHING, unique=True)

	def __str__(self):
		if self.power_drop and power_drop != 0.0:
			return 'Splitter {} input {}, -{:1.3}dB, fiber end id {}'.format(self.optical_splitter.id, self.input_label, self.power_drop, self.fiber_end.id)
		else:
			return 'Splitter {} output {}, fiber end id {}'.format(self.optical_splitter.id, self.input_label, self.fiber_end.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_input'


class OpticalSplitterInputTemplate(models.Model):
	power_drop = models.FloatField(blank=True, null=True)
	input_label = models.TextField(blank=True, null=True)
	optical_splitter_template = models.ForeignKey('OpticalSplitterTemplate', models.DO_NOTHING)
	fiber_end = models.ForeignKey('OpticalSplitterTemplateFiberEnd', models.DO_NOTHING, unique=True)

	def __str__(self):
		return 'Splitter template {} input {}, -{:1.3}dB, fiber end id {}'.format(self.optical_splitter_template.template_name, self.input_label, self.power_drop, self.fiber_end.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_input_template'


class OpticalSplitterOutput(models.Model):
	power_drop = models.FloatField(blank=True, null=True)
	output_label = models.TextField(blank=True, null=True)
	optical_splitter = models.ForeignKey(OpticalSplitter, models.DO_NOTHING)
	fiber_end = models.ForeignKey(FiberEnd, models.DO_NOTHING, unique=True)

	def __str__(self):
		if self.power_drop and power_drop != 0.0:
			return 'Splitter {} output {}, -{:1.3}dB, fiber end id {}'.format(self.optical_splitter.id, self.output_label, self.power_drop, self.fiber_end.id)
		else:
			return 'Splitter {} output {}, fiber end id {}'.format(self.optical_splitter.id, self.output_label, self.fiber_end.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_output'


class OpticalSplitterOutputTemplate(models.Model):
	power_drop = models.FloatField(blank=True, null=True)
	output_label = models.TextField(blank=True, null=True)
	optical_splitter = models.ForeignKey('OpticalSplitterTemplate', models.DO_NOTHING)
	fiber_end = models.ForeignKey('OpticalSplitterTemplateFiberEnd', models.DO_NOTHING, unique=True)

	def __str__(self):
		return 'Splitter template {} output {}, -{:1.3}dB, fiber end id {}'.format(self.optical_splitter.template_name, self.output_label, self.power_drop, self.fiber_end.id)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_output_template'


class OpticalSplitterStyles(models.Model):
	'Splitter packaging types: Rackmount, steel tube, PVC box, etc'

	id = models.SmallIntegerField(primary_key=True)
	style_label = models.TextField()

	def __str__(self):
		return self.style_label

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_styles'


class OpticalSplitterTemplate(models.Model):
	inputs_count = models.SmallIntegerField()
	outputs_count = models.SmallIntegerField(blank=True, null=True)
	splitter_type = models.ForeignKey('OpticalSplitterTypes', models.DO_NOTHING, blank=True, null=True)
	splitter_style = models.ForeignKey(OpticalSplitterStyles, models.DO_NOTHING, blank=True, null=True)
	template_name = models.TextField()

	def __str__(self):
		return '{}: {}x{} {} {}'.format(self.template_name, str(self.inputs_count), str(self.outputs_count), self.splitter_type.type_label, self.splitter_style.style_label)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_template'


class OpticalSplitterTemplateFiberEnd(models.Model):
	optical_connector_type = models.ForeignKey(OpticalConnectorTypes, models.DO_NOTHING, blank=True, null=True)

	class Meta:
		managed = False
		db_table = 'optical_splitter_template_fiber_end'


class OpticalSplitterTypes(models.Model):
	id = models.SmallIntegerField(primary_key=True)
	type_label = models.TextField()
	symmetric_outputs = models.BooleanField()

	def __str__(self):
		return self.type_label

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'optical_splitter_types'


class PoleAttachment(models.Model):
	height_meters = models.FloatField(blank=True, null=True)
	utility_pole = models.ForeignKey('UtilityPole', models.DO_NOTHING)
	f_permitting_requested = models.BooleanField(blank=True, null=True)
	f_permitting_granted = models.BooleanField()
	built = models.DateTimeField(blank=True, null=True)
	njuns_remarks = models.TextField(blank=True, null=True)
	njuns_ticket = models.TextField(blank=True, null=True)
	njuns_asset_uuid = models.UUIDField(blank=True, null=True)

	def __str__(self):
		return 'attachment to pole ' + str(self.utility_pole)

	def __repr__(self):
		return self.__dict__


	class Meta:
		managed = False
		db_table = 'pole_attachment'


class StrandGuyWire(models.Model):
	sidewalk_standoff_pipe = models.BooleanField(blank=True, null=True)
	pole_attachment = models.ForeignKey(PoleAttachment, models.DO_NOTHING)
	azimuth_from_pole = models.SmallIntegerField(blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)

	def __repr__(self):
		return self.__dict__

	def __str__(self):
		description = 'guy wire on ' + str(self.pole_attachement.utility_pole)
		if self.azimuth_from_pole:
			description += ' az {}'.format(str(self.azimuth_from_pole))
		if self.sidewalk_standoff_pipe:
			description += ' w/ standoff'
		if None == self.built:
			description = 'planned ' + description
		else:
			description += ' built ' + self.built.strftime('%Y-%m-%d')

	class Meta:
		managed = False
		db_table = 'strand_guy_wire'


class StrandLine(models.Model):
	built = models.DateTimeField(blank=True, null=True)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'strand_line'


class UndergroundVault(models.Model):
	latlong = models.PointField()
	depth = models.FloatField(blank=True, null=True)
	width = models.FloatField(blank=True, null=True)
	length = models.FloatField(blank=True, null=True)
	length_units = models.ForeignKey(LengthUnits, models.DO_NOTHING, blank=True, null=True)
	manufacturer_name = models.TextField(blank=True, null=True)
	vault_model = models.TextField(blank=True, null=True)
	built = models.DateTimeField(blank=True, null=True)

	def __str__(self):
		if 'feet' == self.length_units.unit_name:
			dimensions_strings = [ str(int(meters_to_inches(getattr(self, x, 0.0)))) for x in ['depth', 'width', 'length']]
		else:
			dimensions_strings = [ x for x in ['depth', 'width', 'length']]

		return '{} {} {} {}'.format(self.manufacturer_name, self.vault_model, ' x '.join(dimensions_strings), self.length_units.unit_shortsymbol)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'underground_vault'


class UndergroundVaultTemplate(models.Model):
	depth = models.FloatField(blank=True, null=True)
	width = models.FloatField(blank=True, null=True)
	length = models.FloatField(blank=True, null=True)
	length_units = models.ForeignKey(LengthUnits, models.DO_NOTHING, blank=True, null=True)
	manufacturer_name = models.TextField(blank=True, null=True)
	vault_model = models.TextField(blank=True, null=True)
	template_name = models.TextField()

	def __str__(self):
		if 'feet' == self.length_units.unit_name:
			dimensions_strings = [ str(int(meters_to_inches(getattr(self, x, 0.0)))) for x in ['depth', 'width', 'length']]
		else:
			dimensions_strings = [ x for x in ['depth', 'width', 'length']]

		return '{}: {} {} {} {}'.format(self.template_name, self.manufacturer_name, self.vault_model, ' x '.join(dimensions_strings), self.length_units.unit_shortsymbol)

	def __repr__(self):
		return self.__dict__

	class Meta:
		managed = False
		db_table = 'underground_vault_template'


class UtilityPole(models.Model):
	pole_owner = models.TextField(blank=True, null=True)
	pole_owner_primary_label = models.TextField(blank=True, null=True)
	latlong = models.PointField()

	def __str__(self):
		return ' '.join([x for x in [self.pole_owner, self.pole_owner_primary_label] if x])

	def __repr__(self):
		return {'pole_owner': self.pole_owner, 'pole_owner_primary_label': self.pole_owner_primary_label, 'latlong': self.latlong}

	class Meta:
		managed = False
		db_table = 'utility_pole'
