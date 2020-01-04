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

from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from .models import *

# Register your models here.
admin.site.register(Address)
admin.site.register(Building, LeafletGeoAdmin)
admin.site.register(CableFiberEnd)
admin.site.register(Conduit, LeafletGeoAdmin)
admin.site.register(ConduitType)
admin.site.register(ConduitVaultEntryOrEnd)
admin.site.register(EnclosurePort)
admin.site.register(EnclosurePortTemplate)
admin.site.register(Fiber)
admin.site.register(FiberCable)
admin.site.register(FiberCableSegment)
admin.site.register(FiberCableSegmentEnd)
admin.site.register(FiberCableSlackCoil, LeafletGeoAdmin)
admin.site.register(FiberCableSlackCoilLocatedInUndergroundVault)
admin.site.register(FiberCableTemplate)
admin.site.register(FiberConnection)
admin.site.register(FiberConnectionEnclosurePortTemplate)
admin.site.register(FiberConnectionMetaInstanceInheritance)
admin.site.register(FiberEnclosure, LeafletGeoAdmin)
admin.site.register(FiberEnclosureCoverage, LeafletGeoAdmin)
admin.site.register(FiberEnclosureLocatedInUndergroundVault)
admin.site.register(FiberEnclosureTemplate)
admin.site.register(FiberEnd)
admin.site.register(FiberEndMetaInstanceInheritance)
admin.site.register(FiberGroup)
admin.site.register(FiberGroupTemplate)
admin.site.register(FiberGroupTypes)
admin.site.register(FiberIdentifierIndex)
admin.site.register(FiberSplice)
admin.site.register(HistoryBool)
admin.site.register(HistoryBoolDeletion)
admin.site.register(HistoryGeometryLinestring, LeafletGeoAdmin)
admin.site.register(HistoryGeometryLinestringDeletion, LeafletGeoAdmin)
admin.site.register(HistoryGeometryPoint, LeafletGeoAdmin)
admin.site.register(HistoryGeometryPointDeletion, LeafletGeoAdmin)
admin.site.register(HistoryInteger)
admin.site.register(HistoryIntegerDeletion)
admin.site.register(HistoryReal)
admin.site.register(HistoryRealDeletion)
admin.site.register(HistoryRowCreation)
admin.site.register(HistoryRowDeletion)
admin.site.register(HistorySmallint)
admin.site.register(HistorySmallintDeletion)
admin.site.register(HistoryText)
admin.site.register(HistoryTextDeletion)
admin.site.register(LengthUnits)
admin.site.register(LoadSupportAttachment)
admin.site.register(LoadSupportAttachmentPoint, LeafletGeoAdmin)
admin.site.register(MapBookmark, LeafletGeoAdmin)
admin.site.register(OpticalConnectorTypes)
admin.site.register(OpticalSplitter)
admin.site.register(OpticalSplitterInput)
admin.site.register(OpticalSplitterInputTemplate)
admin.site.register(OpticalSplitterOutput)
admin.site.register(OpticalSplitterOutputTemplate)
admin.site.register(OpticalSplitterStyles)
admin.site.register(OpticalSplitterTemplate)
admin.site.register(OpticalSplitterTemplateFiberEnd)
admin.site.register(OpticalSplitterTypes)
admin.site.register(PoleAttachment)
admin.site.register(StrandGuyWire)
admin.site.register(StrandLine)
admin.site.register(UndergroundVault, LeafletGeoAdmin)
admin.site.register(UndergroundVaultTemplate)
admin.site.register(UtilityPole, LeafletGeoAdmin)

