# Child Health Monitoring System - Complete Development Prompt

## Project Overview

Build a comprehensive web-based Child Health Monitoring System for Early Childhood Care and Development (ECCD) programs. This system tracks children's health, nutrition status, developmental assessments, and growth metrics across multiple daycare centers. The system implements DSWD (Department of Social Welfare and Development) ECCD guidelines for child health monitoring.

## Technical Stack Requirements

**Backend:**
- Laravel 11.x
- PHP 8.2+
- MySQL 8.0+

**Frontend:**
- Bootstrap 5
- Alpine.js for interactive components
- Chart.js for data visualization

**Key Packages:**
- `spatie/laravel-permission` - Role and permission management
- `maatwebsite/excel` - Excel import/export functionality
- `barryvdh/laravel-dompdf` - PDF report generation
- `spatie/laravel-activitylog` - Audit trail logging

**Authentication:**
- Laravel Breeze with Bootstrap scaffolding
- Role-based access control (RBAC)

---

## System Architecture

### Multi-Tenancy Model
- Municipality-based data segregation
- Center-based worker assignment
- Workers can only access data from their assigned center
- Admins have system-wide access

### User Roles & Permissions

**1. Super Admin**
- Full system access
- Manage all municipalities and centers
- System configuration
- User management across all centers
- View all reports

**2. Municipality Admin**
- Manage centers within their municipality
- Manage workers within their municipality
- View municipality-wide reports
- Cannot access other municipalities' data

**3. Center Coordinator**
- Manage their assigned center
- Manage workers in their center
- Enroll students
- View center-specific reports

**4. Teacher/Worker**
- Record student measurements (weighing, height)
- Conduct developmental assessments
- Record feeding and immunization data
- View students assigned to them
- Generate class reports

**5. Viewer/Inspector**
- Read-only access
- View reports and statistics
- No data entry capabilities

---

## Database Schema Requirements

### Core Entities

**1. Municipalities**
```
- id
- name
- code
- province
- region
- status (active/inactive)
- timestamps
```

**2. Centers**
```
- id
- municipality_id (FK)
- name
- code
- address
- barangay
- contact_number
- email
- center_head_name
- status (active/inactive)
- timestamps
- soft_deletes
```

**3. Workers (Teachers/Staff)**
```
- id
- user_id (FK to users)
- center_id (FK)
- first_name
- middle_name
- last_name
- suffix
- birth_date
- gender
- address
- contact_number
- job_status (permanent/temporary/volunteer)
- date_hired
- date_resigned (nullable)
- status (active/inactive)
- timestamps
- soft_deletes
```

**4. School Years**
```
- id
- name (e.g., "SY 2024-2025")
- start_date
- end_date
- is_current (boolean)
- status (active/inactive)
- timestamps
```

**5. Cycles**
```
- id
- school_year_id (FK)
- center_id (FK)
- name (e.g., "Cycle 1", "Cycle 2")
- start_date
- end_date
- worker_id (FK - assigned teacher)
- status (active/inactive)
- timestamps
```

**6. Students**
```
- id
- center_id (FK)
- first_name
- middle_name
- last_name
- suffix
- birth_date
- gender (male/female)
- address
- barangay
- municipality
- province
- sector (4Ps/IPs/Solo Parent/PWD/Regular)
- status (active/inactive/graduated/transferred)
- profile_photo (nullable)
- timestamps
- soft_deletes
```

**7. Student Parents**
```
- id
- student_id (FK)
- relationship (father/mother/guardian)
- first_name
- middle_name
- last_name
- suffix
- occupation
- contact_number
- timestamps
```

**8. Student Enrollments**
```
- id
- student_id (FK)
- cycle_id (FK)
- worker_id (FK - assigned teacher)
- enrollment_date
- student_type (new/repeater)
- status (enrolled/completed/dropped)
- completion_date (nullable)
- timestamps
```

**9. Weighing Schedules**
```
- id
- cycle_id (FK)
- center_id (FK)
- schedule_date
- weighing_type (upon_entry/20_days/40_days/terminal)
- status (scheduled/completed/cancelled)
- created_by (FK to users)
- timestamps
```

**10. Student Measurements (Weighing)**
```
- id
- student_id (FK)
- cycle_id (FK)
- weighing_schedule_id (FK)
- measurement_date
- weighing_type (upon_entry/20_days/40_days/terminal)
- age_in_months (calculated)
- weight_kg (decimal 5,2)
- height_cm (decimal 5,2)
- bmi (decimal 5,2 - calculated)
- weight_for_age_status (severely_underweight/underweight/normal/overweight)
- height_for_age_status (severely_stunted/stunted/normal/tall)
- weight_for_height_status (severely_wasted/wasted/normal/overweight/obese)
- wfa_zscore (decimal 5,2)
- hfa_zscore (decimal 5,2)
- wfh_zscore (decimal 5,2)
- nutrition_status (normal/mam/sam/overweight/obese)
- remarks (text)
- recorded_by (FK to users)
- timestamps
```

**11. Assessment Schedules**
```
- id
- cycle_id (FK)
- center_id (FK)
- assessment_date
- assessment_type (initial/mid_cycle/terminal)
- status (scheduled/completed/cancelled)
- created_by (FK to users)
- timestamps
```

**12. Developmental Assessments**
```
- id
- student_id (FK)
- cycle_id (FK)
- assessment_schedule_id (FK)
- assessment_date
- assessment_type (initial/mid_cycle/terminal)
- age_in_months (calculated)
- gross_motor_raw_score
- gross_motor_scaled_score
- fine_motor_raw_score
- fine_motor_scaled_score
- self_help_raw_score
- self_help_scaled_score
- receptive_language_raw_score
- receptive_language_scaled_score
- expressive_language_raw_score
- expressive_language_scaled_score
- cognitive_raw_score
- cognitive_scaled_score
- social_emotional_raw_score
- social_emotional_scaled_score
- total_scaled_score
- developmental_status (advanced/normal/at_risk/delayed)
- recommendations (text)
- assessed_by (FK to users)
- timestamps
```

**13. Assessment Domain Items**
```
- id
- domain (gross_motor/fine_motor/self_help/receptive_language/expressive_language/cognitive/social_emotional)
- age_range (e.g., "0-12", "13-24", "25-36")
- item_description
- order
- status (active/inactive)
- timestamps
```

**14. Student Assessment Responses**
```
- id
- assessment_id (FK)
- domain_item_id (FK)
- response (passed/failed/not_applicable)
- notes (text, nullable)
- timestamps
```

**15. Feeding Records**
```
- id
- student_id (FK)
- cycle_id (FK)
- feeding_date
- meal_type (breakfast/lunch/snack)
- food_items (text)
- beverage
- remarks
- recorded_by (FK to users)
- timestamps
```

**16. Immunization Records**
```
- id
- student_id (FK)
- immunization_date
- vaccine_type (bcg/dpt/opv/measles/hepatitis_b/etc)
- dose_number
- administered_by
- health_center
- remarks
- recorded_by (FK to users)
- timestamps
```

**17. Z-Score Reference Tables**

**weight_for_age_boys**
```
- id
- age_in_months
- sd_neg_3
- sd_neg_2
- sd_neg_1
- sd_0
- sd_pos_1
- sd_pos_2
- sd_pos_3
```

**weight_for_age_girls** (same structure)

**height_for_age_boys** (same structure)

**height_for_age_girls** (same structure)

**weight_for_height_boys**
```
- id
- height_cm
- sd_neg_3
- sd_neg_2
- sd_neg_1
- sd_0
- sd_pos_1
- sd_pos_2
- sd_pos_3
```

**weight_for_height_girls** (same structure)

---

## Feature Requirements

### Module 1: Authentication & User Management

**Features:**
1. User login with email and password
2. Password reset functionality
3. User profile management
4. Role assignment (using Spatie Permission)
5. Activity logging for all user actions
6. Session timeout after 30 minutes of inactivity

**Permissions to Create:**
```
- view_dashboard
- manage_municipalities
- manage_centers
- manage_workers
- manage_students
- enroll_students
- record_measurements
- conduct_assessments
- record_feeding
- record_immunization
- view_reports
- export_reports
- manage_settings
- manage_users
- view_audit_logs
```

---

### Module 2: Municipality & Center Management

**Municipality Management (Super Admin only):**
- Create/Edit/Delete municipalities
- Assign municipality admins
- View statistics per municipality
- Export municipality list

**Center Management:**
- Create/Edit/Delete daycare centers
- Assign centers to municipalities
- Upload center photo
- Manage center information
- View center statistics
- List of centers with search and filter
- Export center list to Excel

**UI Requirements:**
- DataTables for listing with search, sort, pagination
- Modal forms for create/edit
- Confirmation dialogs for delete
- Status indicators (active/inactive badges)

---

### Module 3: Worker Management

**Features:**
- Add new workers with user account creation
- Assign workers to centers
- Track job status (permanent/temporary/volunteer)
- Record hire date and resignation date
- View worker profile with assigned students
- List workers with filters (center, status, job type)
- Bulk import workers from Excel
- Export worker list

**Worker Profile Page:**
- Personal information
- Assigned center
- Current cycles/classes
- Number of students
- Recent activities
- Edit and deactivate options

**Initial Password:**
- Auto-generate secure random password
- Send via email or display once to admin
- Force password change on first login

---

### Module 4: Student Management

**Student Registration:**
- Multi-step registration form:
  - Step 1: Personal Information
  - Step 2: Parent/Guardian Information
  - Step 3: Additional Information (sector, address details)
- Photo upload (optional)
- Duplicate detection (check similar names and birthdates)
- Automatic age calculation

**Student Profile:**
- Personal information card
- Parent/guardian information
- Enrollment history
- Growth chart (weight and height over time)
- BMI chart
- Latest nutrition status
- Assessment results history
- Feeding records
- Immunization records
- Action buttons (Edit, Enroll, Add Measurement, Conduct Assessment)

**Student Listing:**
- Filter by center, cycle, status, sector, gender, age range
- Search by name
- Sort by name, age, enrollment date
- Bulk actions (export selected, print IDs)
- Export to Excel with all data
- Student cards view or table view toggle

---

### Module 5: School Year & Cycle Management

**School Year Management:**
- Create school years (SY 2024-2025)
- Set start and end dates
- Mark current school year
- Archive old school years
- Cannot delete school year with enrollments

**Cycle Management:**
- Create cycles within school years
- Assign teacher/worker to cycle
- Set cycle dates (start/end)
- View enrolled students count
- Copy cycle setup from previous year

**Student Enrollment:**
- Select student (existing or new)
- Select cycle
- Set student type (new/repeater)
- Assign to teacher
- Record enrollment date
- Cannot enroll same student in same cycle twice

---

### Module 6: Weighing & Measurement System

**Weighing Schedule:**
- Create weighing schedule for a cycle
- Schedule types: Upon Entry, 20 Days, 40 Days, Terminal
- Set schedule date
- Track completion status
- Send reminders (optional)

**Record Measurements:**
- Select weighing schedule or create ad-hoc measurement
- List of students in cycle
- For each student, record:
  - Measurement date
  - Weight (kg) - with decimal input
  - Height (cm) - with decimal input
- Auto-calculate upon save:
  - Age in months at measurement date
  - BMI
  - Weight-for-Age Z-score and status
  - Height-for-Age Z-score and status
  - Weight-for-Height Z-score and status
  - Overall nutrition status
- Validation rules:
  - Weight: 1-50 kg
  - Height: 40-150 cm
- Save and continue to next student
- Option to skip students (absent)

**BMI Calculation Formula:**
```
BMI = (weight_kg / (height_cm / 100)²)
```

**Z-Score Calculation:**
- Compare measured value with WHO reference tables
- Use student's age (months) and gender
- Calculate standard deviations from median
- Formula: Z-score = (observed - median) / SD

**Nutrition Status Classification:**

Weight-for-Age:
- Z-score < -3: Severely Underweight
- Z-score -3 to <-2: Underweight
- Z-score -2 to +2: Normal
- Z-score > +2: Overweight

Height-for-Age:
- Z-score < -3: Severely Stunted
- Z-score -3 to <-2: Stunted
- Z-score -2 to +2: Normal
- Z-score > +2: Tall

Weight-for-Height:
- Z-score < -3: Severely Wasted (SAM)
- Z-score -3 to <-2: Wasted (MAM)
- Z-score -2 to +1: Normal
- Z-score +1 to +2: Overweight
- Z-score > +2: Obese

Overall Nutrition Status (priority-based):
1. SAM (Severely Wasted)
2. MAM (Moderately Wasted)
3. Obese
4. Overweight
5. Normal

**Growth Monitoring Charts:**
- Line charts showing weight over time
- Line charts showing height over time
- BMI trend chart
- Color-coded zones (red: danger, yellow: at risk, green: normal)
- Compare with WHO growth standards (percentile lines)
- Export chart as image

---

### Module 7: Developmental Assessment System

**Assessment Schedule:**
- Create assessment schedule for cycle
- Assessment types: Initial, Mid-Cycle, Terminal
- Set assessment date
- Track completion status

**Conduct Assessment:**
- Select assessment schedule
- List students in cycle
- For each student:
  - Display checklist of domain items based on age
  - 7 domains: Gross Motor, Fine Motor, Self Help, Receptive Language, Expressive Language, Cognitive, Social-Emotional
  - Mark each item: Passed / Failed / Not Applicable
  - Add notes per item
- Auto-calculate raw scores (count of passed items per domain)
- Convert raw scores to scaled scores using conversion table
- Sum scaled scores for total
- Determine developmental status:
  - Advanced: Total scaled > 115
  - Normal: Total scaled 85-115
  - At Risk: Total scaled 70-84
  - Delayed: Total scaled < 70
- Add overall recommendations
- Save and generate assessment report

**Assessment Conversion Tables:**
- Pre-loaded tables mapping raw scores to scaled scores by age range
- Separate tables per domain
- Admin can configure conversion tables

**Assessment Reports:**
- Individual student assessment report (PDF)
- Domain profile chart (radar/spider chart)
- Comparison across assessment periods
- List of students needing intervention

---

### Module 8: Feeding Program

**Features:**
- Record daily feeding
- Select multiple students
- Record date, meal type, food items, beverage
- Bulk entry for class
- Feeding calendar view
- Monthly feeding report per student
- Export feeding records

**Feeding Summary Reports:**
- Feeding attendance rate by cycle
- Most common foods served
- Students with irregular feeding

---

### Module 9: Immunization Tracking

**Features:**
- Record immunization per student
- Vaccine types (BCG, DPT, OPV, Measles, MMR, Hepatitis B, etc.)
- Track dose numbers (1st, 2nd, 3rd, booster)
- Record administering facility
- Immunization card view
- Due date calculator
- Reminders for upcoming vaccines
- Export immunization summary

---

### Module 10: Dashboard & Analytics

**Super Admin Dashboard:**
- Total municipalities, centers, workers, students
- Active cycles count
- Recent activities feed
- Nutrition status distribution (pie chart)
- Developmental status distribution (pie chart)
- Growth trends (line chart)
- Center comparison charts
- Top performing centers
- Students needing intervention count

**Center Dashboard:**
- Center statistics
- Current cycle information
- Student count by status
- Nutrition status breakdown
- Upcoming schedules (weighing, assessments)
- Recent enrollments
- Quick actions (Add Student, Record Measurement, etc.)

**Worker Dashboard:**
- My cycles
- My students count
- Students needing attention
- Today's schedule
- Quick record entry
- Student list with status indicators

**Charts & Visualizations:**
- Use Chart.js
- Interactive tooltips
- Export as image
- Responsive design

---

### Module 11: Reports & Export

**Standard Reports:**

1. **Center Profile Report**
   - Center details
   - Worker list
   - Student statistics
   - Facilities and resources
   - Export: PDF

2. **Student List Report**
   - Filter by center, cycle, status
   - Columns: Name, Age, Gender, Sector, Nutrition Status, Dev Status
   - Export: Excel, PDF

3. **Nutrition Monitoring Report**
   - Student measurements over time
   - Before and after comparison (entry vs terminal)
   - Improved/Deteriorated/No Change counts
   - By center, by cycle
   - Export: Excel, PDF

4. **Growth Monitoring Report**
   - Individual student growth chart
   - Class growth statistics
   - Distribution by nutrition categories
   - Export: PDF with charts

5. **Developmental Assessment Report**
   - Individual assessment results
   - Domain scores breakdown
   - Comparison across periods
   - Students by developmental status
   - Export: PDF

6. **Feeding Program Report**
   - Feeding attendance by month
   - Per student feeding record
   - Menu summary
   - Export: Excel

7. **Immunization Report**
   - Complete immunization list
   - Vaccine coverage statistics
   - Due and overdue vaccines
   - Export: Excel, PDF

8. **Comprehensive Child Report**
   - All data for one student
   - Growth charts
   - Assessment history
   - Feeding and immunization
   - Recommendations
   - Export: PDF (printable portfolio)

9. **Summary Statistics Report**
   - Municipality/Center/Cycle level
   - Enrollments, nutrition, assessments
   - Comparison tables
   - Export: Excel with pivot tables

**Report Features:**
- Date range filters
- Multiple filter options
- Preview before export
- Scheduled reports (optional)
- Email delivery option
- Report templates customization

---

### Module 12: Settings & Configuration

**General Settings:**
- System name and logo
- Contact information
- Terms and conditions
- Default values (passwords, etc.)

**Assessment Configuration:**
- Manage domain items
- Raw to scaled score conversion tables
- Age range definitions
- Developmental status thresholds

**Z-Score Reference Data:**
- Import WHO reference tables
- Update reference data
- Download templates

**Backup & Maintenance:**
- Database backup
- Export all data
- System health check
- Activity logs viewer

---

## Business Logic & Calculations

### Age Calculation
```php
// Calculate age in months at specific date
$birthDate = Carbon::parse($student->birth_date);
$measurementDate = Carbon::parse($measurement->measurement_date);
$ageInMonths = $birthDate->diffInMonths($measurementDate);
```

### BMI Calculation
```php
$bmi = $weight_kg / (($height_cm / 100) ** 2);
$bmi = round($bmi, 2);
```

### Z-Score Calculation
```php
// Pseudo-code for Weight-for-Age
1. Get student's age in months and gender
2. Look up reference table (weight_for_age_boys or weight_for_age_girls)
3. Get median (SD_0) and standard deviations (SD_NEG_1, SD_POS_1, etc.)
4. Calculate Z-score using WHO formula:
   - If weight >= median:
     Z = (weight - median) / (SD_POS_1 - median)
   - If weight < median:
     Z = (weight - median) / (median - SD_NEG_1)
5. Round to 2 decimals
6. Classify status based on Z-score thresholds
```

### Nutrition Status Priority Logic
```php
if (wfh_status == 'severely_wasted') {
    return 'SAM';
} elseif (wfh_status == 'wasted') {
    return 'MAM';
} elseif (wfh_status == 'obese') {
    return 'Obese';
} elseif (wfh_status == 'overweight' || wfa_status == 'overweight') {
    return 'Overweight';
} else {
    return 'Normal';
}
```

### Assessment Scoring
```php
// Count passed items per domain
$raw_score = StudentAssessmentResponse::where('assessment_id', $id)
    ->where('domain_item_id', 'IN', $domain_items)
    ->where('response', 'passed')
    ->count();

// Convert to scaled score using conversion table
$scaled_score = AssessmentConversionTable::where('domain', $domain)
    ->where('age_range', $age_range)
    ->where('raw_score', $raw_score)
    ->first()
    ->scaled_score;

// Sum all scaled scores
$total_scaled = array_sum($all_scaled_scores);

// Determine status
if ($total_scaled > 115) return 'Advanced';
elseif ($total_scaled >= 85) return 'Normal';
elseif ($total_scaled >= 70) return 'At Risk';
else return 'Delayed';
```

---

## UI/UX Requirements

### Design Principles
- Clean, professional healthcare system aesthetic
- Mobile-responsive (Bootstrap 5 grid)
- Accessible (WCAG 2.1 AA compliance)
- Fast loading (optimized queries)
- Intuitive navigation

### Color Scheme
- Primary: Blue (trust, healthcare)
- Success: Green (healthy, normal status)
- Warning: Yellow/Orange (at risk, needs attention)
- Danger: Red (critical, urgent action needed)
- Info: Light blue (information, guidance)

### Layout
- **Header**: Logo, system name, user menu, notifications
- **Sidebar**: Main navigation (collapsible on mobile)
- **Breadcrumbs**: Show current location
- **Content Area**: Main content with cards/panels
- **Footer**: Copyright, version, links

### Forms
- Use Bootstrap 5 form components
- Inline validation with error messages
- Required field indicators (*)
- Help text/tooltips for complex fields
- Progress indicators for multi-step forms
- Auto-save for long forms (optional)

### Tables & Lists
- Server-side pagination
- Search functionality
- Column sorting
- Row actions (Edit, Delete, View)
- Bulk actions checkboxes
- Empty state messages
- Loading skeletons

### Cards & Widgets
- Student cards with photo, name, age, status badges
- Statistics cards with icons and numbers
- Activity feed cards
- Chart widgets

### Notifications
- Toast notifications for success/error messages
- Alert boxes for important information
- Badge indicators for pending actions

### Icons
- Use Bootstrap Icons or Font Awesome
- Consistent icon usage throughout

---

## Security Requirements

### Authentication & Authorization
- Strong password requirements (min 8 chars, uppercase, lowercase, number)
- Password hashing with bcrypt
- Failed login attempt tracking and account lockout
- CSRF protection on all forms
- Session fixation prevention
- Secure password reset flow with expiring tokens

### Data Protection
- Input validation and sanitization
- SQL injection prevention (use Eloquent ORM)
- XSS prevention (Blade templating escapes output)
- Mass assignment protection
- Rate limiting on sensitive endpoints

### Access Control
- Middleware-based route protection
- Permission checks before data access
- Row-level security (users see only their center's data)
- Audit logging of sensitive actions

### File Upload Security
- Validate file types (images only for photos)
- Limit file sizes (max 2MB for photos)
- Store files outside public directory
- Generate unique filenames
- Scan uploads for malware (optional)

---

## Testing Requirements

### Unit Tests
- Model relationships
- Business logic (BMI, Z-score calculations)
- Helper functions
- Service classes

### Feature Tests
- Authentication flows
- CRUD operations for all modules
- Permission enforcement
- Report generation
- Excel export

### Browser Tests (optional)
- Critical user flows
- Form submissions
- File uploads

---

## Performance Requirements

### Database Optimization
- Proper indexing on foreign keys and search columns
- Eager loading to prevent N+1 queries
- Query result caching for reference data
- Database query optimization

### Caching Strategy
- Cache WHO reference tables (rarely change)
- Cache user permissions
- Cache dashboard statistics (5 minute TTL)
- Cache reports for repeated requests

### Asset Optimization
- Minify CSS and JS
- Use Laravel Mix or Vite
- Optimize images
- Enable browser caching

---

## Deployment Requirements

### Environment Configuration
- Separate .env files for dev/staging/production
- Environment-specific configurations
- Secure secret keys

### Database
- Regular automated backups
- Migration rollback capability
- Seeder for initial data (roles, permissions, reference tables)

### Server Requirements
- PHP 8.2+
- MySQL 8.0+
- Redis (for caching and queues)
- Supervisor (for queue workers)
- HTTPS/SSL certificate

---

## Initial Setup & Seeding

### Seeders to Create

**1. RoleAndPermissionSeeder**
```php
// Create roles
$superAdmin = Role::create(['name' => 'Super Admin']);
$municipalityAdmin = Role::create(['name' => 'Municipality Admin']);
$centerCoordinator = Role::create(['name' => 'Center Coordinator']);
$teacher = Role::create(['name' => 'Teacher']);
$viewer = Role::create(['name' => 'Viewer']);

// Create permissions and assign to roles
```

**2. WhoReferenceDataSeeder**
- Import Z-score reference tables from WHO data files
- Weight-for-age (boys/girls)
- Height-for-age (boys/girls)
- Weight-for-height (boys/girls)

**3. AssessmentDomainSeeder**
- Create assessment domain items by age range
- Create raw-to-scaled conversion tables

**4. DemoDataSeeder** (for testing only)
- Sample municipality
- Sample centers (3-5)
- Sample workers (10-15)
- Sample students (50-100)
- Sample measurements
- Sample assessments

---

## Documentation Requirements

### Code Documentation
- PHPDoc blocks for all classes and methods
- Inline comments for complex logic
- README with setup instructions

### User Documentation
- User manual (PDF)
- Video tutorials for key features
- System admin guide
- FAQ section

---

## Maintenance & Support

### Logging
- Application logs (Laravel log)
- User activity audit trail
- Error tracking (optional: Sentry, Bugsnag)

### Monitoring
- Database query performance
- Application performance metrics
- User session monitoring
- Error rate tracking

---

## Future Enhancements (Phase 2)

- Mobile app (iOS/Android)
- SMS notifications for parents
- QR code student IDs
- Facial recognition attendance
- Telemedicine integration
- Parent portal
- Predictive analytics for health risks
- Multi-language support
- Offline mode with sync

---

## Development Phases

### Phase 1 (Month 1-2): Foundation
- [ ] Laravel 11 setup with Bootstrap 5 UI
- [ ] Authentication with Breeze
- [ ] Spatie Permission setup
- [ ] Database migrations
- [ ] Seeders for roles, permissions, reference data
- [ ] Base layout and navigation
- [ ] User management module
- [ ] Municipality and Center management

### Phase 2 (Month 3): Core Modules
- [ ] Worker management
- [ ] Student management
- [ ] School year and cycle management
- [ ] Student enrollment
- [ ] Dashboard basics

### Phase 3 (Month 4): Health Monitoring
- [ ] Weighing schedules
- [ ] Measurement recording
- [ ] BMI calculation
- [ ] Z-score calculation
- [ ] Nutrition status classification
- [ ] Growth charts

### Phase 4 (Month 5): Assessment System
- [ ] Assessment schedules
- [ ] Conduct assessments
- [ ] Assessment scoring
- [ ] Assessment reports
- [ ] Domain profile charts

### Phase 5 (Month 6): Additional Features
- [ ] Feeding program module
- [ ] Immunization tracking
- [ ] Complete dashboard with all charts
- [ ] Activity audit logs

### Phase 6 (Month 7): Reports & Export
- [ ] All standard reports
- [ ] Excel export with formatting
- [ ] PDF generation with charts
- [ ] Report templates

### Phase 7 (Month 8): Testing & Polish
- [ ] Comprehensive testing
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] Security audit
- [ ] User documentation
- [ ] Deployment preparation

---

## Success Criteria

✅ All modules fully functional
✅ All reports generate correctly
✅ BMI and Z-score calculations accurate
✅ Assessment scoring works correctly
✅ Role-based access control enforced
✅ Responsive design on mobile/tablet/desktop
✅ Fast page loads (<2 seconds)
✅ No security vulnerabilities
✅ Comprehensive test coverage (>80%)
✅ Complete user documentation
✅ Successfully deployed to production

---

## Technical Notes

### Laravel 11 Specifics
- Use new simplified directory structure
- Utilize Laravel 11's improved routing
- Leverage new health check endpoint
- Use Eloquent strict mode
- Implement new rate limiting features

### Bootstrap 5 UI
- Use Bootstrap 5 components (cards, modals, forms)
- Implement Bootstrap 5 utilities
- Use Bootstrap 5 icons or Font Awesome
- Ensure ARIA accessibility attributes
- Mobile-first responsive design

### Spatie Permission
```php
// Middleware usage
Route::middleware(['permission:manage_students'])->group(function () {
    // Routes
});

// Blade directives
@can('manage_students')
    // UI elements
@endcan

// Controller checks
if (!auth()->user()->can('manage_students')) {
    abort(403);
}
```

### Excel Import/Export
```php
// Export example
return (new StudentsExport)->download('students.xlsx');

// Import example
Excel::import(new StudentsImport, request()->file('file'));
```

---

## API Endpoints (Optional for Phase 2)

If building mobile app or API:

```
POST   /api/auth/login
POST   /api/auth/logout
GET    /api/students
POST   /api/students
GET    /api/students/{id}
PUT    /api/students/{id}
POST   /api/measurements
GET    /api/measurements/{student_id}
POST   /api/assessments
GET    /api/reports/nutrition
GET    /api/dashboard/stats
```

---

## Questions to Address During Development

1. Should students be able to transfer between centers mid-cycle?
2. Can a worker teach multiple cycles simultaneously?
3. How to handle students who miss weighing schedules?
4. What happens when a cycle is deleted with existing data?
5. Can historical measurements be edited or deleted?
6. Should the system send email/SMS reminders automatically?
7. How long should audit logs be retained?
8. Should there be a mobile-friendly teacher view?

---

## Conclusion

This comprehensive specification covers all aspects of the Child Health Monitoring System. The system should be built incrementally following the development phases, with testing at each phase. Priority should be given to data accuracy (especially BMI and Z-score calculations) and security (role-based access control and data protection).

The end result should be a professional, user-friendly system that helps daycare workers effectively monitor and improve child health outcomes according to ECCD guidelines.

---

**Good luck with development! 🚀**
