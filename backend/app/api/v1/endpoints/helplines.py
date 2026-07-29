from typing import List
from fastapi import APIRouter
from app.schemas.features import HelplineResponse

router = APIRouter()

# Mocking static helplines for now, could be fetched from DB
STATIC_HELPLINES = [
    {"id": "00000000-0000-0000-0000-000000000001", "name": "Women Helpline (All India)", "phone": "1091", "category": "Women Safety"},
    {"id": "00000000-0000-0000-0000-000000000002", "name": "Police", "phone": "100", "category": "General Emergency"},
    {"id": "00000000-0000-0000-0000-000000000003", "name": "National Emergency Number", "phone": "112", "category": "General Emergency"},
    {"id": "00000000-0000-0000-0000-000000000004", "name": "Domestic Abuse", "phone": "181", "category": "Women Safety"}
]

@router.get("/", response_model=List[HelplineResponse])
def get_helplines():
    """Get versioned static list of emergency helplines."""
    return STATIC_HELPLINES
