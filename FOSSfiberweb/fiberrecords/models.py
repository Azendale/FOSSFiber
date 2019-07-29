# Create your models here.

# Begin inspectdb auto generated section:
# MANUALLY EDITED!!!!!
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.contrib.gis.db import models


class Building(models.Model):
    id = models.IntegerField(primary_key=True)
    address_number = models.TextField(blank=True, null=True)
    street = models.TextField(blank=True, null=True)
    city = models.TextField(blank=True, null=True)
    state = models.TextField(blank=True, null=True)
    zip = models.TextField(blank=True, null=True)
    suite_apt = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'building'


class BuildingAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    building = models.ForeignKey(Building, models.DO_NOTHING)
    attachment_point = models.PointField()

    class Meta:
        managed = False
        db_table = 'building_attachment'


class BuildingAttachmentMetaInstance(models.Model):
    building_attachment = models.ForeignKey(BuildingAttachment, models.DO_NOTHING, primary_key=True)
    inheriting_table_name = models.TextField()
    inheriting_cable_fk_column_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'building_attachment_meta_instance'
        unique_together = (('building_attachment', 'inheriting_table_name', 'inheriting_cable_fk_column_name'),)


class CableFiberEnd(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber = models.ForeignKey('Fiber', models.DO_NOTHING)
    start_end = models.BooleanField()
    fiber_end = models.ForeignKey('FiberEnd', models.DO_NOTHING, unique=True)
    meterage = models.FloatField()

    class Meta:
        managed = False
        db_table = 'cable_fiber_end'


class ConduitType(models.Model):
    id = models.IntegerField(primary_key=True)
    diameter = models.FloatField(blank=True, null=True)
    diameter_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='diameter_units', blank=True, null=True, related_name='used_as_conduit_diameter')
    length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True)
    conduit_type_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'conduit_type'


class EnclosurePort(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_enclosure = models.ForeignKey('FiberEnclosure', models.DO_NOTHING)
    port_label = models.TextField(blank=True, null=True)
    fiber_connection = models.ForeignKey('FiberConnection', models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'enclosure_port'


class EnclosurePortTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_enclosure_template = models.ForeignKey('FiberEnclosureTemplate', models.DO_NOTHING)
    port_label = models.TextField(blank=True, null=True)
    fiber_connection_template = models.ForeignKey('FiberConnectionEnclosurePortTemplate', models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'enclosure_port_template'


class Fiber(models.Model):
    id = models.IntegerField(primary_key=True)
    cable = models.ForeignKey('FiberCable', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber'


class FiberCable(models.Model):
    id = models.IntegerField(primary_key=True)
    cable_start_length_measure = models.FloatField(blank=True, null=True)
    cable_end_length_measure = models.FloatField(blank=True, null=True)
    length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True)
    fiber_groups_depth = models.SmallIntegerField(blank=True, null=True)
    f_armored = models.BooleanField(blank=True, null=True)
    f_outdoor = models.BooleanField(blank=True, null=True)
    fiber_groups_top_level_count = models.SmallIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_cable'


class FiberCableAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_cable_meterage = models.FloatField()
    fiber_cable_meterage_is_guess = models.BooleanField()
    fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_cable_attachment'


class FiberCableAttachmentMetaInstanceInheritance(models.Model):
    fiber_cable_attachment = models.ForeignKey(FiberCableAttachment, models.DO_NOTHING, primary_key=True)
    inheriting_table_name = models.TextField()
    inheriting_table_fk_column_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'fiber_cable_attachment_meta_instance_inheritance'
        unique_together = (('fiber_cable_attachment', 'inheriting_table_name', 'inheriting_table_fk_column_name'),)


class FiberCableBuildingAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    building_attachment = models.ForeignKey(BuildingAttachment, models.DO_NOTHING)
    fiber_cable_attachment = models.ForeignKey(FiberCableAttachment, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_cable_building_attachment'


class FiberCableLocatedInFiberEnclosure(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)
    fiber_enclosure = models.ForeignKey('FiberEnclosure', models.DO_NOTHING)
    cable_entry_in_meterage = models.FloatField(blank=True, null=True)
    cable_entry_out_meterage = models.FloatField(blank=True, null=True)
    in_tape_marking = models.TextField(blank=True, null=True)
    out_tape_marking = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_cable_located_in_fiber_enclosure'


class FiberCablePoleAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_cable_attachment = models.ForeignKey(FiberCableAttachment, models.DO_NOTHING)
    pole_attachment = models.ForeignKey('PoleAttachment', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_cable_pole_attachment'


class FiberCableSlackCoil(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_cable = models.ForeignKey(FiberCable, models.DO_NOTHING)
    in_meterage = models.FloatField(blank=True, null=True)
    latlong = models.PointField(geography=True, blank=True, null=True)
    out_meterage = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_cable_slack_coil'


class FiberCableSlackCoilLocatedInUndergroundVault(models.Model):
    id = models.IntegerField(primary_key=True)
    underground_vault = models.ForeignKey('UndergroundVault', models.DO_NOTHING)
    fiber_cable_slack_loop = models.ForeignKey(FiberCableSlackCoil, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_cable_slack_coil_located_in_underground_vault'


class FiberCableStrandAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    segment_percentage = models.FloatField(blank=True, null=True)
    strand_attachment_a = models.ForeignKey('StrandAttachment', models.DO_NOTHING, related_name='as_FiberCableStrandAttachment_a')
    strand_attachment_b = models.ForeignKey('StrandAttachment', models.DO_NOTHING, blank=True, null=True, related_name='as_FiberCableStrandAttachment_b')
    fiber_cable_attachment = models.ForeignKey(FiberCableAttachment, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_cable_strand_attachment'


class FiberCableTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    length_units = models.ForeignKey('LengthUnits', models.DO_NOTHING, db_column='length_units', blank=True, null=True)
    fiber_groups_depth = models.SmallIntegerField(blank=True, null=True)
    f_armored = models.BooleanField(blank=True, null=True)
    f_outdoor = models.BooleanField(blank=True, null=True)
    fiber_groups_top_level_count = models.SmallIntegerField(blank=True, null=True)
    template_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'fiber_cable_template'


class FiberConnection(models.Model):
    id = models.IntegerField(primary_key=True)
    connected_fiber_end_a = models.ForeignKey('FiberEnd', models.DO_NOTHING, blank=True, null=True, related_name='connected_to_a_side')
    connected_fiber_end_b = models.ForeignKey('FiberEnd', models.DO_NOTHING, blank=True, null=True, related_name='connected_to_b_side')
    a_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='as_fiber_connection_a_side')
    b_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='as_fiber_connection_b_side')

    class Meta:
        managed = False
        db_table = 'fiber_connection'


class FiberConnectionEnclosurePortTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    a_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='as_FiberConnectionEnclosurePortTemplate_a')
    b_optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True, related_name='as_FiberConnectionEnclosurePortTemplate_b')

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
    id = models.IntegerField(primary_key=True)
    longlat = models.PointField(geography=True, blank=True, null=True)
    manufacturer_name = models.TextField(blank=True, null=True)
    enclosure_model = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_enclosure'


class FiberEnclosureLocatedInUndergroundVault(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_enclosure = models.ForeignKey(FiberEnclosure, models.DO_NOTHING)
    underground_vault = models.ForeignKey('UndergroundVault', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_enclosure_located_in_underground_vault'


class FiberEnclosureTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    manufacturer_name = models.TextField(blank=True, null=True)
    enclosure_model = models.TextField(blank=True, null=True)
    template_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'fiber_enclosure_template'


class FiberEnd(models.Model):
    id = models.IntegerField(primary_key=True)
    optical_connector_type = models.ForeignKey('OpticalConnectorTypes', models.DO_NOTHING, blank=True, null=True)

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

    class Meta:
        managed = False
        db_table = 'fiber_group'


class FiberGroupTemplate(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    subgroup_count = models.SmallIntegerField(blank=True, null=True)
    group_type = models.ForeignKey('FiberGroupTypes', models.DO_NOTHING)
    level = models.SmallIntegerField(blank=True, null=True)
    fiber_cable_template = models.ForeignKey(FiberCableTemplate, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_group_template'


class FiberGroupTypes(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    shortname = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_group_types'


class FiberIdentifierIndex(models.Model):
    id = models.IntegerField(primary_key=True)
    group_index = models.SmallIntegerField(blank=True, null=True)
    group_level = models.SmallIntegerField(blank=True, null=True)
    fiber = models.ForeignKey(Fiber, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'fiber_identifier_index'


class FiberSplice(models.Model):
    id = models.IntegerField(primary_key=True)
    fiber_connection = models.ForeignKey(FiberConnection, models.DO_NOTHING, unique=True)
    fusion = models.BooleanField(blank=True, null=True)
    estimated_loss = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fiber_splice'


class HistoryBool(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.BooleanField(blank=True, null=True)
    after_value = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_bool'


class HistoryBoolDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_bool_deletion'


class HistoryGeometryLinestring(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.LineStringField(blank=True, null=True)
    after_value = models.LineStringField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_geometry_linestring'


class HistoryGeometryLinestringDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.LineStringField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_geometry_linestring_deletion'


class HistoryGeometryPoint(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.PointField(blank=True, null=True)
    after_value = models.PointField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_geometry_point'


class HistoryGeometryPointDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.PointField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_geometry_point_deletion'


class HistoryInteger(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.IntegerField(blank=True, null=True)
    after_value = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_integer'


class HistoryIntegerDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_integer_deletion'


class HistoryReal(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.FloatField(blank=True, null=True)
    after_value = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_real'


class HistoryRealDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey('HistoryRowDeletion', models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_real_deletion'


class HistoryRowCreation(models.Model):
    table_name = models.TextField()
    table_id = models.IntegerField()
    username = models.TextField(blank=True, null=True)
    creation = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'history_row_creation'


class HistoryRowDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    table_id = models.IntegerField()
    username = models.TextField(blank=True, null=True)
    deletion = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'history_row_deletion'


class HistorySmallint(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.SmallIntegerField(blank=True, null=True)
    after_value = models.SmallIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_smallint'


class HistorySmallintDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey(HistoryRowDeletion, models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.SmallIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_smallint_deletion'


class HistoryText(models.Model):
    id = models.IntegerField(primary_key=True)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.TextField(blank=True, null=True)
    after_value = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_text'


class HistoryTextDeletion(models.Model):
    id = models.IntegerField(primary_key=True)
    history_row_deletion = models.ForeignKey(HistoryRowDeletion, models.DO_NOTHING)
    table_name = models.TextField()
    column_name = models.TextField()
    change_date = models.DateTimeField()
    username = models.TextField(blank=True, null=True)
    before_value = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'history_text_deletion'


class LengthUnits(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    unit_name = models.TextField()
    unit_shortsymbol = models.TextField()

    class Meta:
        managed = False
        db_table = 'length_units'


class OpticalConnectorTypes(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    name = models.TextField()
    gender = models.CharField(max_length=1, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'optical_connector_types'


class OpticalSplitter(models.Model):
    id = models.IntegerField(primary_key=True)
    inputs_count = models.SmallIntegerField()
    outputs_count = models.SmallIntegerField(blank=True, null=True)
    splitter_type = models.ForeignKey('OpticalSplitterTypes', models.DO_NOTHING, blank=True, null=True)
    splitter_style = models.ForeignKey('OpticalSplitterStyles', models.DO_NOTHING, blank=True, null=True)
    containing_fiber_enclosure = models.ForeignKey(FiberEnclosure, models.DO_NOTHING, db_column='containing_fiber_enclosure', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter'


class OpticalSplitterInput(models.Model):
    id = models.IntegerField(primary_key=True)
    power_drop = models.FloatField(blank=True, null=True)
    input_label = models.TextField(blank=True, null=True)
    optical_splitter = models.ForeignKey(OpticalSplitter, models.DO_NOTHING)
    fiber_end = models.ForeignKey(FiberEnd, models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter_input'


class OpticalSplitterInputTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    power_drop = models.FloatField(blank=True, null=True)
    input_label = models.TextField(blank=True, null=True)
    optical_splitter_template = models.ForeignKey('OpticalSplitterTemplate', models.DO_NOTHING)
    fiber_end = models.ForeignKey('OpticalSplitterTemplateFiberEnd', models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter_input_template'


class OpticalSplitterOutput(models.Model):
    id = models.IntegerField(primary_key=True)
    power_drop = models.FloatField(blank=True, null=True)
    output_label = models.TextField(blank=True, null=True)
    optical_splitter = models.ForeignKey(OpticalSplitter, models.DO_NOTHING)
    fiber_end = models.ForeignKey(FiberEnd, models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter_output'


class OpticalSplitterOutputTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    power_drop = models.FloatField(blank=True, null=True)
    output_label = models.TextField(blank=True, null=True)
    optical_splitter = models.ForeignKey('OpticalSplitterTemplate', models.DO_NOTHING)
    fiber_end = models.ForeignKey('OpticalSplitterTemplateFiberEnd', models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter_output_template'


class OpticalSplitterStyles(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    style_label = models.TextField()

    class Meta:
        managed = False
        db_table = 'optical_splitter_styles'


class OpticalSplitterTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    inputs_count = models.SmallIntegerField()
    outputs_count = models.SmallIntegerField(blank=True, null=True)
    splitter_type = models.ForeignKey('OpticalSplitterTypes', models.DO_NOTHING, blank=True, null=True)
    splitter_style = models.ForeignKey(OpticalSplitterStyles, models.DO_NOTHING, blank=True, null=True)
    template_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'optical_splitter_template'


class OpticalSplitterTemplateFiberEnd(models.Model):
    id = models.IntegerField(primary_key=True)
    optical_connector_type = models.ForeignKey(OpticalConnectorTypes, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'optical_splitter_template_fiber_end'


class OpticalSplitterTypes(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    type_label = models.TextField()
    symmetric_outputs = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'optical_splitter_types'


class PoleAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    height_meters = models.FloatField(blank=True, null=True)
    utility_pole = models.ForeignKey('UtilityPole', models.DO_NOTHING)
    f_permitting_requested = models.BooleanField(blank=True, null=True)
    f_permitting_granted = models.BooleanField()
    f_built = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pole_attachment'


class PoleAttachmentMetaInstanceInheritance(models.Model):
    pole_attachment = models.ForeignKey(PoleAttachment, models.DO_NOTHING, primary_key=True)
    inheriting_table_name = models.TextField()
    inheriting_table_fk_column_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'pole_attachment_meta_instance_inheritance'
        unique_together = (('pole_attachment', 'inheriting_table_name', 'inheriting_table_fk_column_name'),)


class StrandAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    strand_line = models.ForeignKey('StrandLine', models.DO_NOTHING)
    strand_line_squence = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'strand_attachment'


class StrandAttachmentMetaInstanceInheritance(models.Model):
    strand_attachment = models.ForeignKey(StrandAttachment, models.DO_NOTHING, primary_key=True)
    inheriting_table_name = models.TextField()
    inheriting_table_fk_column_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'strand_attachment_meta_instance_inheritance'
        unique_together = (('strand_attachment', 'inheriting_table_name', 'inheriting_table_fk_column_name'),)


class StrandBuildingAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    building_attachment = models.ForeignKey(BuildingAttachment, models.DO_NOTHING)
    strand_attachment = models.ForeignKey(StrandAttachment, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'strand_building_attachment'


class StrandGuyWire(models.Model):
    id = models.IntegerField(primary_key=True)
    sidewalk_standoff_pipe = models.BooleanField(blank=True, null=True)
    pole_attachment = models.ForeignKey(PoleAttachment, models.DO_NOTHING)
    azimuth_from_pole = models.SmallIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'strand_guy_wire'


class StrandLine(models.Model):
    id = models.IntegerField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'strand_line'


class StrandPoleAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    pole_attachment = models.ForeignKey(PoleAttachment, models.DO_NOTHING)
    strand_attachment = models.ForeignKey(StrandAttachment, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'strand_pole_attachment'


class StrandToStrandAttachment(models.Model):
    id = models.IntegerField(primary_key=True)
    percentage_along_segment = models.FloatField()
    segment_strand_attachment_a = models.ForeignKey(StrandAttachment, models.DO_NOTHING, related_name='as_StrandToStrandAttachment_a')
    segment_strand_attachment_b = models.ForeignKey(StrandAttachment, models.DO_NOTHING, related_name='as_StrandToStrandAttachment_b')
    strand_attachment = models.ForeignKey(StrandAttachment, models.DO_NOTHING, related_name='as_StrandToStrandAttachment_baseclass')

    class Meta:
        managed = False
        db_table = 'strand_to_strand_attachment'


class UndergroundConduit(models.Model):
    id = models.IntegerField(primary_key=True)
    length = models.FloatField(blank=True, null=True)
    start_underground_vault_entry = models.ForeignKey('UndergroundVault', models.DO_NOTHING, blank=True, null=True, related_name='as_UndergroundConduit_entry_a')
    end_underground_vault_entry = models.ForeignKey('UndergroundVault', models.DO_NOTHING, blank=True, null=True, related_name='as_UndergroundConduit_entry_b')
    conduit_route = models.LineStringField(blank=True, null=True)
    conduit_type = models.ForeignKey(ConduitType, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'underground_conduit'


class UndergroundVault(models.Model):
    id = models.IntegerField(primary_key=True)
    latlong = models.PointField()
    depth = models.FloatField(blank=True, null=True)
    width = models.FloatField(blank=True, null=True)
    length = models.FloatField(blank=True, null=True)
    length_units = models.ForeignKey(LengthUnits, models.DO_NOTHING, blank=True, null=True)
    manufacturer_name = models.TextField(blank=True, null=True)
    vault_model = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'underground_vault'


class UndergroundVaultTemplate(models.Model):
    id = models.IntegerField(primary_key=True)
    depth = models.FloatField(blank=True, null=True)
    width = models.FloatField(blank=True, null=True)
    length = models.FloatField(blank=True, null=True)
    length_units = models.ForeignKey(LengthUnits, models.DO_NOTHING, blank=True, null=True)
    manufacturer_name = models.TextField(blank=True, null=True)
    vault_model = models.TextField(blank=True, null=True)
    template_name = models.TextField()

    class Meta:
        managed = False
        db_table = 'underground_vault_template'


class UtilityPole(models.Model):
    id = models.IntegerField(primary_key=True)
    pole_owner = models.TextField(blank=True, null=True)
    pole_owner_primary_label = models.TextField(blank=True, null=True)
    latlong = models.PointField()

    class Meta:
        managed = False
        db_table = 'utility_pole'

# End inspectdb auto generated section

