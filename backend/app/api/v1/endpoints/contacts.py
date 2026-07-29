import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.models.features import Contact
from app.schemas.features import ContactCreate, ContactUpdate, ContactResponse

router = APIRouter()

@router.get("/", response_model=List[ContactResponse])
def get_contacts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieve all contacts for the current user."""
    contacts = db.query(Contact).filter(Contact.user_id == current_user.id).all()
    return contacts

@router.post("/", response_model=ContactResponse, status_code=status.HTTP_201_CREATED)
def create_contact(
    contact_in: ContactCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new contact."""
    contact = Contact(**contact_in.model_dump(), user_id=current_user.id)
    db.add(contact)
    db.commit()
    db.refresh(contact)
    return contact

@router.put("/{contact_id}", response_model=ContactResponse)
def update_contact(
    contact_id: uuid.UUID,
    contact_in: ContactUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update a contact."""
    contact = db.query(Contact).filter(Contact.id == contact_id, Contact.user_id == current_user.id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact not found")
    
    update_data = contact_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(contact, field, value)
        
    db.add(contact)
    db.commit()
    db.refresh(contact)
    return contact

@router.delete("/{contact_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_contact(
    contact_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete a contact."""
    contact = db.query(Contact).filter(Contact.id == contact_id, Contact.user_id == current_user.id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact not found")
        
    db.delete(contact)
    db.commit()
    return None
