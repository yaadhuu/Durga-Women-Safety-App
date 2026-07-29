import uuid
from datetime import datetime

from pydantic import BaseModel, EmailStr, Field


# ── Requests ──


class RegisterRequest(BaseModel):
    email: str = Field(..., max_length=255, examples=["user@example.com"])
    password: str = Field(..., min_length=8, max_length=128)
    full_name: str = Field(..., max_length=255, examples=["Priya Sharma"])
    phone: str = Field(..., max_length=20, examples=["+919876543210"])


class LoginRequest(BaseModel):
    email: str = Field(..., max_length=255)
    password: str = Field(..., min_length=8, max_length=128)


# ── Responses ──


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    full_name: str
    phone: str
    is_active: bool
    created_at: datetime

    model_config = {"from_attributes": True}
