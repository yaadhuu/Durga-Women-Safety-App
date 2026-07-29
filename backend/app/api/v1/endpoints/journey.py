import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.models.features import Journey
from app.schemas.features import JourneyCreate, JourneyUpdate, JourneyResponse

router = APIRouter()

@router.post("/start", response_model=JourneyResponse, status_code=status.HTTP_201_CREATED)
def start_journey(
    journey_in: JourneyCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Start a new journey."""
    journey = Journey(**journey_in.model_dump(), user_id=current_user.id)
    db.add(journey)
    db.commit()
    db.refresh(journey)
    return journey

@router.put("/{journey_id}/update", response_model=JourneyResponse)
def update_journey(
    journey_id: uuid.UUID,
    journey_in: JourneyUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update a journey (e.g. current location or status)."""
    journey = db.query(Journey).filter(Journey.id == journey_id, Journey.user_id == current_user.id).first()
    if not journey:
        raise HTTPException(status_code=404, detail="Journey not found")
    
    update_data = journey_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(journey, field, value)
        
    db.add(journey)
    db.commit()
    db.refresh(journey)
    return journey

@router.post("/{journey_id}/stop", response_model=JourneyResponse)
def stop_journey(
    journey_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Stop an active journey."""
    journey = db.query(Journey).filter(Journey.id == journey_id, Journey.user_id == current_user.id).first()
    if not journey:
        raise HTTPException(status_code=404, detail="Journey not found")
        
    journey.is_active = False
    db.add(journey)
    db.commit()
    db.refresh(journey)
    return journey
