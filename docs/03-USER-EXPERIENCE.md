# Expathio — User Experience

**Status:** IN DISCUSSION  
**Document type:** User experience specification  
**Project:** Expathio

---

## 1. Purpose

This document defines the experience of a participant inside Expathio.

It describes how people discover organizations, join them, assume professional roles, interact with coworkers, perform activities, receive feedback, and develop their careers.

The goal is to make participation feel like being part of a real organization rather than completing isolated exercises in a learning platform.

The participant should feel like an active member of the company.

## 2. Core Experience Principles

The participant experience must follow these principles. The project-wide design principles are in `00-VISION.md`, section 8; the list below applies them to the participant experience.

- **Membership:** Participants are members of an organization, not external students completing assignments.
- **Responsibility:** Participants receive responsibilities associated with their roles.
- **Context:** Activities must have organizational context and meaningful objectives.
- **Continuity:** The organization continues operating when participants are absent.
- **Consequences:** Decisions and actions can influence other departments, coworkers, customers, and business outcomes.
- **Professional realism:** Work should resemble real professional responsibilities and interactions.
- **Career development:** Participants should be able to build a professional trajectory within the organization.
- **Agency:** Participants should have meaningful choices about how they approach their responsibilities.

## 3. Discovering Expathio

When someone accesses Expathio for the first time, they should understand that the platform provides access to simulated organizations.

The experience should communicate that each organization has its own:

- Industry and business model.
- Organizational structure.
- Departments and professional roles.
- Culture and working environment.
- Current business situation.
- Operational activities and challenges.

Participants should be able to explore available organizations before joining one.

The platform should eventually support multiple organizations with different industries, structures, and opportunities.

## 4. Joining an Organization

Joining an organization should represent entering a professional environment.

The participant should have enough information to understand:

- What the organization does.
- Its current situation.
- Which departments exist.
- Which roles are available.
- What responsibilities each role involves.
- What level of experience or knowledge may be expected.

Participants apply to predefined vacancies, which simulate a hiring process (`docs/decisions/0005-admission-model.md`).

Possible approaches include direct role selection, application and approval, recruitment processes, or a combination depending on the organization.

The experience should avoid making role selection feel like choosing a simple game character. A role represents actual responsibilities within the organization.

## 5. Assuming a Professional Role

Once accepted, the participant becomes part of a department and receives responsibilities associated with that position.

A role should define:

- Position and professional title.
- Department.
- Main responsibilities.
- Expected activities.
- Access to relevant information and tools.
- Relationships with other roles.
- Decision-making authority.
- Performance expectations.

Roles should have meaningful differences.

For example, a marketing professional, financial analyst, software developer, and operations coordinator should encounter different workflows, information, decisions, and responsibilities.

The platform must not assume that every participant is a developer or that every organization revolves around technology.

## 6. The Participant Workspace

The participant needs a central workspace where they can understand and manage their professional activities.

The workspace should provide access to relevant information without overwhelming the participant.

Conceptually, it may include:

### 6.1 Overview

A summary of the participant's current situation:

- Current role and department.
- Pending responsibilities.
- Important organizational events.
- Recent updates.
- Relevant notifications.
- Career status and milestones.

### 6.2 Tasks and Responsibilities

Participants should be able to understand what requires their attention.

Activities should provide sufficient context to make decisions and perform meaningful work.

A task may include:

- Description and background.
- Objective.
- Priority.
- Deadline.
- Dependencies.
- Relevant people or departments.
- Expected deliverables.
- Acceptance criteria.
- Current status.
- Activity history.

The participant should understand why the task exists and how it relates to the organization's objectives.

### 6.3 Communication

Communication should be an important part of the experience.

Participants may need to interact with:

- Coworkers.
- Managers.
- Other departments.
- Customers, when appropriate to their role.
- Organizational leadership.

Communication should support coordination, clarification, negotiation, feedback, and decision-making.

It should not exist merely as decorative conversation.

### 6.4 Organizational Information

Participants should have access to information relevant to their responsibilities.

Examples include:

- Company announcements.
- Internal documents.
- Policies and procedures.
- Business indicators.
- Departmental reports.
- Project information.
- Historical decisions.

Access to information should respect professional responsibilities and organizational permissions.

## 6.5. Device Experience and Platform Usage

Expathio is designed primarily as a desktop experience.

The computer is the participant's main working environment and the place where professional activities must be performed.

The desktop experience should provide the tools, information density, navigation, and interaction capabilities required to perform realistic professional work.

### Desktop — Primary Work Environment

The desktop is required for activities such as:

- Managing and executing tasks.
- Producing and editing deliverables.
- Analyzing business information and reports.
- Working with organizational tools.
- Managing projects and workflows.
- Reviewing data and operational indicators.
- Participating in complex professional activities.
- Making decisions that affect organizational processes.

The desktop interface should prioritize productivity, clarity, contextual information, and efficient workflows.

### Smartphone — Communication and Information

Smartphone usage should be intentionally limited to lightweight information exchange. Smartphone use is a future consideration and is not part of the initial release.

Examples include:

- Reading and replying to emails.
- Receiving and reading messages.
- Viewing notifications.
- Reading company announcements.
- Receiving urgent updates.
- Checking basic information about pending responsibilities.

Smartphones should not provide the full working environment or replace the desktop experience.

Activities that require substantial interaction, complex analysis, document production, or operational execution should direct participants to use a computer.

### Design Principle

The smartphone is a communication channel, not a portable workstation.

Expathio should simulate the distinction between receiving information while away from work and actually performing professional responsibilities at a workstation.

## 7. Day-to-Day Participation

The experience should resemble participation in an organization with ongoing activity.

A participant may:

1. Access their workspace.
2. Review updates and pending responsibilities.
3. Receive new activities or requests.
4. Communicate with coworkers.
5. Analyze information and make decisions.
6. Execute work and produce deliverables.
7. Submit results for review when necessary.
8. Receive feedback or requests for adjustments.
9. Observe the consequences of their actions.
10. Follow the organization's ongoing developments.

This sequence is illustrative, not a mandatory daily routine.

Different roles and departments should have different working patterns.

Some responsibilities may require immediate attention, while others involve longer projects, recurring activities, or collaboration across departments.

## 8. Tasks, Deliverables, and Feedback

Completing a task should not always mean simply changing its status to completed.

When appropriate, participants should produce tangible deliverables.

Examples include:

- Reports.
- Analyses.
- Business proposals.
- Technical implementations.
- Financial projections.
- Marketing campaigns.
- Operational plans.
- Process improvements.
- Decisions and recommendations.

Deliverables may be reviewed by managers, coworkers, or other organizational processes.

Feedback should be contextual and explain what was effective, what needs improvement, and why.

The system should distinguish between:

- Work submitted.
- Work accepted.
- Work requiring adjustments.
- Work rejected.
- Work that produced observable business outcomes.

Not every activity needs a formal approval process. The level of review should depend on the role, responsibility, and organizational context.

## 9. Collaboration

Expathio should support professional collaboration rather than treating every participant as an isolated worker.

Some activities should require coordination between different roles or departments.

Examples:

- Marketing coordinating a campaign with product and operations.
- Finance evaluating the financial impact of a proposed initiative.
- Technology implementing a solution requested by another department.
- Customer service communicating recurring customer problems to product management.
- Operations coordinating inventory and logistics.

Participants should be able to understand how their work affects others and how other people's work affects their responsibilities.

The platform should eventually support multiple human participants within the same organization.

The exact collaboration model and concurrency rules remain open.

## 10. Organizational Events and Notifications

Participants should become aware of events that matter to their responsibilities.

Examples include:

- New assignments.
- Changes in task priorities.
- Requests from managers.
- Customer complaints requiring attention.
- Project updates.
- Approval requests.
- Departmental announcements.
- Business incidents.
- Changes affecting previously completed work.

Notifications should be contextual and useful.

The system should avoid overwhelming participants with irrelevant activity.

Not every event needs to generate a notification. Importance should depend on the participant's role, responsibilities, and relationship to the event.

## 11. Career Development

Participation in Expathio should allow people to build a professional trajectory within an organization.

The participant should be able to progress through a career rather than simply accumulate completed tasks.

Career development may include:

- Increased responsibilities.
- Recognition for meaningful contributions.
- Performance evaluations.
- Experience-based progression.
- Promotions.
- Changes in professional title.
- Fictional salary increases.
- Bonuses and other rewards.
- Access to more complex activities.
- Greater autonomy and decision-making authority.

Progression should combine performance-based recognition with experience and time spent in the organization.

The participant should feel that they are building a career inside the company, with achievements and responsibilities accumulating over time.

Detailed progression rules, compensation mechanics, promotion criteria, and reward systems are defined in `07-PROGRESSION-AND-REWARDS.md`.

## 12. Absence and Return

Participants are not expected to remain continuously active.

When someone leaves the platform, the organization should continue operating.

During their absence:

- Business processes may continue.
- Customers may interact with the company.
- Coworkers may perform their responsibilities.
- New events may occur.
- Existing situations may evolve.
- Some responsibilities may become overdue or require reassignment.

When the participant returns, the experience should help them understand what happened.

They should be able to identify:

- Important organizational developments.
- Changes affecting their responsibilities.
- New assignments.
- Missed events.
- Decisions made during their absence.
- Consequences that require their attention.

The return experience should provide context without requiring the participant to reconstruct everything manually.

## 13. Changing Roles or Leaving an Organization

The participant should eventually be able to change positions, departments, or organizations.

Such transitions should respect organizational context.

A role change may require:

- An available position.
- Approval from management.
- A transition period.
- Transfer of existing responsibilities.
- A record of previous contributions.

Leaving an organization should not erase the participant's professional history.

Previous roles, achievements, evaluations, and contributions should remain part of their Expathio profile.

The exact transition and departure mechanics remain open.

## 14. Professional Identity and History

Participants should develop a professional identity within Expathio.

Their history may include:

- Organizations they joined.
- Roles they occupied.
- Responsibilities they assumed.
- Projects they contributed to.
- Deliverables they produced.
- Performance evaluations.
- Promotions and achievements.
- Important decisions and outcomes.

This history should provide a meaningful record of professional experience inside simulated organizations.

The platform should prioritize evidence of actual contributions over superficial activity metrics.

## 15. Experience Design Constraints

The participant experience should follow these constraints:

- Avoid presenting the platform as a conventional online course.
- Avoid reducing work to disconnected missions or generic quests.
- Avoid excessive gamification that undermines professional realism.
- Avoid overwhelming participants with simulated activity.
- Avoid assigning tasks without sufficient context.
- Avoid making every interaction dependent on AI.
- Avoid requiring continuous presence.
- Avoid making every role follow the same workflow.
- Preserve organizational continuity and historical context.
- Make important consequences understandable to participants.

## 16. Open Questions

Product questions, such as admission, role freedom and role transitions, are listed in `01-PRODUCT.md`, section 11. The questions below are specific to the participant experience.

- How should participants discover and compare organizations?
- What should the main workspace prioritize?
- How should communication be organized?
- Which activities require formal deliverables?
- How should managers review participant work?
- How should notifications be prioritized?
- How should the platform handle simultaneous human participants?
- How should absence affect responsibilities?
- How should professional history be presented?
- How should the experience balance realism, accessibility, and engagement?

These questions must be resolved before the participant workspace is built in Phase 4 (`docs/06-ROADMAP.md`, section 7). Any answer needed earlier by the Experience and Design session is raised with the owner at that time.

## 17. Visual Direction

The visual identity of the Expathio platform is defined in `09-DESIGN-SYSTEM.md`. The identity of the fictional company simulated inside Expathio is defined in `08-COMPANY.md`. The two must not be confused in the interface.
