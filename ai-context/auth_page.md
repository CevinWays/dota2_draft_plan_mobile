# Authentication Pages — Specification (Login & Register)

## 1. User Stories

### Login Page
**As a** Dota 2 strategist  
**I want to** log in with my email and password  
**So that** I can access my saved draft plans and synchronize my tactical notes.

### Register Page
**As a** new user  
**I want to** create a new account  
**So that** I can start building and saving my own dota 2 draft plans.

---

## 2. Acceptance Criteria

### Login Criteria
- [x] **Plan Identity**: Displays "DOTA 2 DRAFT PLANS" in large bold caps with "TACTICAL STRATEGY HUB" as the subtitle.
- [x] **Fields**: Includes "EMAIL ADDRESS" and "PASSWORD" input fields.
- [x] **Buttons**: "LOGIN" button (Red/Orange accent) to submit the form.
- [x] **Forgot Password**: Provides a "Forgot Access?" link near the password field.

### Register Criteria
- [x] **Identity**: Displays "Create Account" title with "Join the elite strategists. Plan your victory." subtitle.
- [x] **Fields**: Includes "FULL NAME", "EMAIL ADDRESS", "PASSWORD", and "CONFIRM PASSWORD".
- [x] **Buttons**: "SIGN UP" button to submit the registration.
- [x] **Navigation**: "Already have an account? Back to Login" link at the bottom.

### Validation Rules (Applied to both)
- [x] **Email**: Must be a valid email format.
- [x] **Password**: Must be at least 8 characters long.
- [x] **Confirm Password**: Must exactly match the Password field (Register only).
- [x] **Name**: Full name field should not be empty (Register only).

---

## 3. UI Components Breakdown

### A. Global Layout
- **Background**: Deep Dark Background (#121212).
- **Logo**: Orange grid icon (4 squares) inside a circular dark frame. Use `CachedNetworkImage` if the logo is a remote asset.
- **Form Card**: Semi-transparent dark container with a subtle 1px gray border.

### B. Input Fields
- **Label**: Modern, uppercase, small-caps gray text above the input.
- **Decoration**:
    - Dark fill background.
    - Subtle 1px border.
    - Placeholder text in muted gray (Example: "dragon.knight@radiant.com").
- **Contrast**: Higher contrast border/glow on focus.

### C. Primary Action Buttons
- **Style**: Solid Red-Orange background (#FF5252).
- **Text**: White, Uppercase, Bold (e.g., "LOGIN" or "SIGN UP").
- **Shape**: Rounded corners (approx. 8px).

### D. Links & Typography
- **Accent Links**: Vibrant orange text (e.g., "Forgot Access?", "Back to Login").
- **Secondary Text**: Muted grays for labels, subtitles, and "Already have an account?" text.

---

## 4. Interactions & States

| State | Behavior |
|---|---|
| **Default** | Fields showing placeholders. Submit buttons enabled. |
| **Focus** | Input borders should subtly brighten or change color when active. |
| **Error** | Red outline on invalid fields. Error message text below the field if validation fails. |
| **Loading** | Loading spinner replaces button text during API authentication. |
| **Success** | Navigates to the "Draft Plans List" page upon successful auth. |

---

## 5. Technical Design (Clean Architecture)

### Domain Layer
- **Entity**: `User` (id, email, fullName, token).
- **Repository Interface**: `AuthRepository` with `login(email, password)` and `register(name, email, password)`.
- **Use Cases**: `LoginUseCase`, `RegisterUseCase`, `CheckAuthStatusUseCase`.

### Data Layer
- **Model**: `UserModel` (extends `User`, handles JSON serialization).
- **DataSource**: `AuthRemoteDataSource` using **Dio** to `POST /login` and `POST /register`.
- **Repository Implementation**: `AuthRepositoryImpl` that implements the interface and handles token storage.

### Presentation Layer
- **State Management**: `AuthCubit` using **Cubit/Bloc**.
    - States: `AuthInitial`, `AuthLoading`, `Authenticated`, `Unauthenticated`, `AuthError`.
- **Pages**:
    - `LoginPage`: Renders the login form.
    - `RegisterPage`: Renders the registration form.
- **Widgets**:
    - `AuthTextField`: Custom styled input with validation.
    - `AuthActionButton`: Custom styled button with loading state.

---

## 6. Project Compliance Rules
- **Flutter Version**: 3.38.9.
- **Networking**: Use **Dio** via `DioClient`.
- **Image Loading**: Use **CachedNetworkImage** for all remote assets.
- **State Management**: Strict adherence to **Cubit**.
- **Architecture**: Enforced 3-layer **Clean Architecture**.
