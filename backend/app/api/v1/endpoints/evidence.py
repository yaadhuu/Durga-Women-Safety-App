import uuid
import os
import shutil
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, status
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.models.features import Evidence
from app.schemas.features import EvidenceResponse

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/upload", response_model=EvidenceResponse, status_code=status.HTTP_201_CREATED)
async def upload_evidence(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Upload evidence to local disk (mocking cloud upload) and record to DB."""
    file_extension = os.path.splitext(file.filename)[1]
    filename = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join(UPLOAD_DIR, filename)
    
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail="Could not save file")
        
    evidence = Evidence(
        user_id=current_user.id,
        file_path=file_path,
        file_type=file.content_type or "unknown"
    )
    db.add(evidence)
    db.commit()
    db.refresh(evidence)
    return evidence
