import uuid
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field

# Contact Schemas
class ContactBase(BaseModel):
    name: str = Field(..., max_length=255)
    phone: str = Field(..., max_length=20)
    relation: Optional[str] = Field(None, max_length=100)

class ContactCreate(ContactBase):
    pass

class ContactUpdate(ContactBase):
    pass

class ContactResponse(ContactBase):
    id: uuid.UUID
    user_id: uuid.UUID
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# SOSAlert Schemas
class SOSAlertBase(BaseModel):
    latitude: Optional[float] = None
    longitude: Optional[float] = None

class SOSAlertCreate(SOSAlertBase):
    pass

class SOSAlertResponse(SOSAlertBase):
    id: uuid.UUID
    user_id: uuid.UUID
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# Journey Schemas
class JourneyBase(BaseModel):
    start_latitude: Optional[float] = None
    start_longitude: Optional[float] = None
    dest_latitude: Optional[float] = None
    dest_longitude: Optional[float] = None

class JourneyCreate(JourneyBase):
    pass

class JourneyUpdate(BaseModel):
    dest_latitude: Optional[float] = None
    dest_longitude: Optional[float] = None
    is_active: Optional[bool] = None

class JourneyResponse(JourneyBase):
    id: uuid.UUID
    user_id: uuid.UUID
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# Evidence Schemas
class EvidenceBase(BaseModel):
    file_path: str = Field(..., max_length=500)
    file_type: str = Field(..., max_length=50)

class EvidenceCreate(EvidenceBase):
    pass

class EvidenceResponse(EvidenceBase):
    id: uuid.UUID
    user_id: uuid.UUID
    created_at: datetime

    class Config:
        from_attributes = True

# Helpline Schemas
class HelplineBase(BaseModel):
    name: str = Field(..., max_length=255)
    phone: str = Field(..., max_length=20)
    category: Optional[str] = Field(None, max_length=100)

class HelplineResponse(HelplineBase):
    id: uuid.UUID

    class Config:
        from_attributes = True

# Threat Schemas
class ThreatRequest(BaseModel):
    text: str

class ThreatResponse(BaseModel):
    risk_level: str
    color: str
