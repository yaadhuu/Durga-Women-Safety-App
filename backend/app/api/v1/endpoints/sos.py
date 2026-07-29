import uuid
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.models.features import SOSAlert
from app.schemas.features import SOSAlertCreate, SOSAlertResponse

router = APIRouter()

@router.post("/trigger", response_model=SOSAlertResponse)
def trigger_sos(
    sos_in: SOSAlertCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Trigger an SOS alert and (mock) send FCM push."""
    sos = SOSAlert(**sos_in.model_dump(), user_id=current_user.id)
    db.add(sos)
    db.commit()
    db.refresh(sos)
    # TODO: Native FCM push implementation here in the future
    return sos

@router.get("/last", response_model=SOSAlertResponse)
def get_last_sos(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieve the most recent active SOS alert for the user."""
    sos = db.query(SOSAlert).filter(
        SOSAlert.user_id == current_user.id,
        SOSAlert.is_active == True
    ).order_by(SOSAlert.created_at.desc()).first()
    return sos
