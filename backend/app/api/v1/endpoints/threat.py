from fastapi import APIRouter
from app.schemas.features import ThreatRequest, ThreatResponse

router = APIRouter()

@router.post("/analyze", response_model=ThreatResponse)
def analyze_threat(request: ThreatRequest):
    """Analyze text for threats (ported from client-side)."""
    text = request.text.lower()
    
    if any(keyword in text for keyword in ["help", "danger", "attack", "follow", "threat", "harass"]):
        return ThreatResponse(risk_level="High Risk", color="red")
    elif not text:
        return ThreatResponse(risk_level="Low Risk", color="green")
    else:
        return ThreatResponse(risk_level="Medium Risk", color="orange")
