# AcademicPilot AI

**Full title:** AcademicPilot AI: A Multi-Agent System for Personalized Academic Guidance

AcademicPilot AI is a working academic prototype built around the closed loop:

**Observe → Analyze → Plan → Learn → Practice → Evaluate → Update → Re-plan**

It is intentionally not implemented as a single chatbot. A LangGraph Coordinator selects specialist agents according to current student state, and every action is visible in the Agent Activity panel.

## What is included

- React + Tailwind CSS frontend.
- FastAPI backend.
- SQLAlchemy relational model; SQLite default, PostgreSQL supported by `DATABASE_URL`.
- LangGraph conditional multi-agent orchestration.
- Academic Brain / Coordinator, Detective, Strategist, Resource, Mentor, Examiner, and Progress Monitor agents.
- Dynamic subjects/topics/subtopics/questions — no five-item limits.
- Configurable mastery weights and thresholds.
- ChromaDB RAG for uploaded PDF/TXT/Markdown learning material.
- Configurable LLM interface with an offline demo provider and an OpenAI-compatible provider.
- Adaptive question counts and difficulty.
- Persistent attempts, mastery, plans, goals, performance history, recommendations, and agent logs.
- Demo student and teacher accounts.
- Tests and academic demo instructions.

## Project layout

```text
academicpilot-ai/
├── frontend/
│   └── src/
│       ├── components/
│       ├── pages/
│       └── services/
├── backend/
│   ├── agents/
│   ├── api/
│   ├── database/
│   ├── models/
│   ├── rag/
│   ├── services/
│   ├── workflows/
│   └── main.py
├── data/
├── docs/
├── tests/
├── docker/
├── .env.example
├── requirements.txt
└── README.md
```

## System design documents

Read these before presenting the implementation:

- `docs/architecture.md` — architecture, ER model, agent state, protocol, LangGraph flow, mastery model, RAG, security.
- `docs/api-and-pages.md` — backend endpoint and frontend route map.
- `docs/development-plan.md` — implementation phases and research upgrades.

## VS Code setup — Windows

### 1. Prerequisites

Install:

- Python 3.11 or 3.12 recommended.
- Node.js 20+.
- Visual Studio Code.
- VS Code Python extension.

Open the folder `academicpilot-ai` in VS Code.

### 2. Create the backend environment

Open **Terminal → New Terminal** in VS Code:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If PowerShell blocks activation, run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### 3. Configure environment

```powershell
Copy-Item .env.example .env
```

The default `.env` uses SQLite and `LLM_PROVIDER=demo`, so no API key is required for the academic demonstration.

For an OpenAI-compatible provider later:

```env
LLM_PROVIDER=openai_compatible
LLM_BASE_URL=https://api.openai.com/v1
LLM_API_KEY=your-key
LLM_MODEL=your-model-name
```

Keep `.env` private.

### 4. Run backend

From the project root with `.venv` active:

```powershell
uvicorn backend.main:app --reload --port 8000
```

Check:

- API health: `http://localhost:8000/api/health`
- Swagger: `http://localhost:8000/docs`

The first startup creates the database and demo records.

### 5. Run frontend

Open a **second VS Code terminal**:

```powershell
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`.

### 6. Demo accounts

Student:

```text
Email: demo@student.ai
Password: Demo@123
```

Teacher:

```text
Email: teacher@academicpilot.ai
Password: Teacher@123
```

These are demo rows only. The schema supports arbitrary future students and academic content.

## How to demonstrate it to your guide / examiner

1. Log in as **Demo Student**.
2. Show Dashboard: overall mastery, multiple subject cards, weak topics, current goal, recommendation.
3. Open **DBMS → Normalization**. The seed mastery is intentionally weak/developing.
4. Click **Run Academic Brain** and explain that LangGraph starts at the Coordinator, which conditionally selects only needed agents.
5. Open **Learn**. Show the Detective diagnosis, Resource Agent retrieval, adaptive plan, and Mentor explanation.
6. Open **Practice**. Leave question count blank to show automatic count based on mastery, or enter a custom count to prove it is not fixed at five.
7. Submit answers. Show new mastery, accuracy, adaptive difficulty, and automatic re-plan.
8. Open **Agent Activity**. Point out the timestamps and decisions from Coordinator, Detective, Resource, Strategist, Examiner, Monitor, etc.
9. Log out and log in as **Demo Teacher**.
10. Open **Teacher/Admin**, add a new subject and topic, then upload a PDF/TXT/Markdown file.
11. Return to the student flow after enrolling/using that content and explain how retrieval is topic-sensitive.

### One-minute architecture explanation

> AcademicPilot AI stores a continuously updated student state rather than treating each prompt independently. A central Coordinator runs in LangGraph and chooses a specialist agent based on intent, mastery, repeated mistakes, and completed actions. The Detective identifies weaknesses, Resource retrieves learning material, Strategist creates/revises a study plan, Mentor explains, Examiner generates adaptive questions, and Monitor updates mastery after real attempts. Worker agents return state to the Coordinator, so the next step is conditionally selected. The graph stops whenever real student input is required, then resumes after that input. This makes the implementation a closed-loop academic guidance workflow rather than a normal question-answer chatbot.

## Run tests

From project root:

```powershell
pytest -q
```

Frontend production check:

```powershell
cd frontend
npm run build
```

## PostgreSQL mode

Create a PostgreSQL database and set:

```env
DATABASE_URL=postgresql+psycopg://username:password@localhost:5432/academicpilot
```

Restart the backend. SQLAlchemy will use the same normalized schema. For production work, add Alembic migrations instead of relying on `create_all`.

## Important implementation notes

- The local demo question generator is deterministic and suitable for showing the architecture without API expenses. It can create a dynamic number of questions, but a final research study should use a reviewed question bank and/or structured LLM generation for assessment validity.
- Short-answer demo grading uses concept-keyword overlap. Objective question types are exact-match graded. For high-stakes assessment, replace this with an appropriate rubric/model plus teacher moderation.
- ChromaDB is used as the vector database. The starter uses deterministic local hash embeddings to avoid requiring an external embedding API. Replace the embedding service for your chosen research setup.
- The project does **not** claim that multi-agent AI itself is novel. The research contribution should be positioned around a focused student-state architecture, adaptive intervention, agent coordination, weak-concept targeting, and continuous re-planning.

## Research evaluation ideas

A useful experimental design is to compare this adaptive system with a static recommendation baseline. Track pre/post topic mastery, time-to-mastery, repeated-error rate, number of re-plans, resource completion, and assessment performance. Ablation studies can remove one feature at a time (RAG, re-planning, weak-concept targeting, adaptive difficulty) to show which components contribute to improvement.

---

## New in this build: Student self-registration

The login screen now includes **Create a new account**. A new student can register with:

- Full name
- Email
- Password + confirmation
- Available study time per day

The backend creates both the `users` and `students` records, generates a unique student code such as `AP-000003`, returns a JWT, and signs the student in immediately. New accounts are not tied to any hard-coded subject list; after registration the student can open **My Subjects** and enroll from the dynamic database catalog.

API endpoint:

```text
POST /api/auth/register
```

## Easiest Windows run method

After the one-time setup, you can avoid PowerShell execution-policy issues completely:

1. Double-click `run_all.bat`.
2. It opens the FastAPI backend and React/Vite frontend in separate command windows.
3. Open `http://localhost:5173` if the browser does not open automatically.

For a first-time machine, double-click `setup_windows.bat` once before `run_all.bat`.

The launchers directly use `.venv\\Scripts\\python.exe` and `C:\\Program Files\\nodejs\\npm.cmd`, so activating `Activate.ps1` is not required.


## Windows quick start

From the project root (`academicpilot-ai`):

```powershell
.\setup_windows.bat
.\run_all.bat
```

The frontend is in `frontend/` and runs on `http://localhost:5173`. The FastAPI backend runs on `http://localhost:8000`; API docs are at `http://localhost:8000/docs`.

### Teacher PDF/RAG upload

The updated upload pipeline extracts selectable PDF text before creating the database resource and Chroma vectors. A PDF is only reported as indexed after chunks have actually been created. Scanned/image PDFs use optional OCR when Tesseract is installed. If OCR is unavailable, the teacher receives a clear error instead of a false successful indexing message.

### Scanned PDF OCR on Windows

Install Tesseract OCR separately and make sure `tesseract.exe` is on PATH. Text-based PDFs do not require Tesseract.


## Resource Agent and Teacher Help Flow

- Teacher uploads the original PDF from **Teacher/Admin**.
- The backend stores the original file under `data/resources` and indexes extracted text for RAG.
- Students see the resource in **Resources** with **Open Original PDF**; the PDF is streamed from the original uploaded file rather than rendered as a text preview.
- When a student uses **Ask & Send to Teacher**, the AI explanation is returned immediately and a `TeacherHelpRequest` is created in the teacher dashboard.
- Teachers can filter open/in-progress/resolved requests and send a response.
