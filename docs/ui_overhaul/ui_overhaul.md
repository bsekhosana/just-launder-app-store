# UI Overhaul - Just Laundrette App

## Objective
Complete UI modernization of the Just Laundrette app with Material 3, white-dominant theme, glass effects, micro-animations, and Font Awesome icons for a professional, trustworthy laundry management experience.

## Context
- **Current State:** Flutter app with basic Material Design
- **Target:** Modern, wellness-focused UI with glass effects and smooth animations
- **Platform:** Mobile-first (iOS/Android) with tablet support
- **Users:** Laundrette owners, staff, drivers

## Design Tokens & Guidelines

### Colors
```dart
Primary: #2563EB (Blue) - Trustworthy, professional
Secondary: #10B981 (Green) - Success, growth
Accent: #F59E0B (Orange) - Attention, warnings
Surface: #FFFFFF (White) - Clean, minimal
Background: #F8FAFC (Light Grey) - Subtle depth
OnSurface: #1B1B1B (Dark Grey) - High contrast text
Success: #20B26C (Green)
Warning: #F5A524 (Orange)
Danger: #E54D2E (Red)
```

### Typography
- **Font Family:** Inter (Google Fonts)
- **Scale:** Material 3 typography scale
- **Weights:** 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)

### Spacing Scale
```dart
xs: 4px, s: 8px, m: 12px, l: 16px, xl: 24px, xxl: 32px
```

### Border Radius
```dart
s: 8px, m: 12px, l: 16px, xl: 28px
```

### Elevation
```dart
low: 1px, med: 3px, high: 6px
```

### Motion
- **Timing:** 200ms (fast), 260ms (normal), 340ms (slow)
- **Curves:** fastOutSlowIn (standard), easeInOutCubic (emphasized)
- **Expressiveness:** Level 3 (polished but not distracting)

### Icons
- **Style:** Font Awesome (Solid + Regular)
- **Primary Actions:** Solid icons
- **Secondary Actions:** Regular icons

## Component Inventory (Old → New Mapping)

### Navigation
- [ ] `AppBar` → `AppBarX` (glass effect, large title, avatar)
- [ ] `BottomNavigationBar` → `NavbarX` (FA icons, badges, animations)

### Forms & Inputs
- [ ] `TextFormField` → `TextFieldX` (floating label, states, animations)
- [ ] `ElevatedButton` → `AnimatedButton` (scale, fade, loading states)
- [ ] `Switch` → `SwitchX` (custom styling, animations)

### Cards & Surfaces
- [ ] `Card` → `CardX` (flat/elevated/glass variants)
- [ ] `Container` → `GlassSurface` (backdrop blur, transparency)
- [ ] `Chip` → `ChipX` (selectable, springy animations)

### Feedback
- [ ] `SnackBar` → `SnackX` (info/success/warn/danger variants)
- [ ] `AlertDialog` → `DialogX` (glass background, animations)

### Lists & Data
- [ ] `ListTile` → `ListTileX` (staggered entrance animations)
- [ ] `GridView` → `GridViewX` (animated grid items)

## Planned Steps ✅ Checklist

### Phase 1: Foundation
- [x] Discovery & Requirements Gathering
- [ ] Create Design System Structure
- [ ] Implement Color Schemes
- [ ] Implement Typography
- [ ] Implement Spacing & Radii
- [ ] Implement Motion System
- [ ] Implement Icon System
- [ ] Create Theme Data

### Phase 2: Primitives
- [ ] GlassSurface Component
- [ ] AnimatedButton Component
- [ ] TextFieldX Component
- [ ] CardX Component
- [ ] ChipX/TagX Component
- [ ] SnackX Component
- [ ] NavbarX Component
- [ ] AppBarX Component

### Phase 3: Screen Migration
- [ ] Authentication Screens
- [ ] Main Navigation
- [ ] Orders Management
- [ ] Branches Management
- [ ] Staff Management
- [ ] Analytics Dashboard
- [ ] Settings Screens

### Phase 4: Testing & Polish
- [ ] Widget Tests
- [ ] Golden Tests (Critical Screens)
- [ ] Performance Optimization
- [ ] Accessibility Testing
- [ ] Animation Refinement

## Current Status
**Today:** Design system foundation completed successfully
**Next:** Create primitive UI components and begin screen migration

## Risks & Mitigations
- **Performance:** Heavy blur effects on low-end devices → Feature flags for blur
- **Bundle Size:** Multiple icon styles → Tree-shaking optimization
- **Accessibility:** Complex animations → Respect "Reduce Motion" setting
- **Breaking Changes:** Gradual migration → Feature flags for new components

## Version History
- **2024-01-XX:** Initial UI overhaul planning and discovery
- **2024-01-XX:** Design system foundation created

## Notes & Open Questions
- Consider adding haptic feedback for button interactions
- Explore custom loading states for different actions
- Plan for dark mode implementation in future phase
- Consider adding onboarding animations for new users

---

## Tasks Completed
- [x] Discovery phase completed with confirmed requirements
- [x] Design tokens and guidelines established
- [x] Source-of-truth documentation created
- [x] Design system structure implemented
- [x] Color schemes with Material 3 colors
- [x] Typography system with Inter font
- [x] Spacing and radius systems
- [x] Elevation and shadow systems
- [x] Motion and animation systems
- [x] Icon system with Font Awesome
- [x] Comprehensive theme configuration
- [x] Main.dart updated to use new theme
- [x] Primitive UI components created (GlassSurface, AnimatedButton, TextFieldX, CardX, ChipX, SnackX)

## Remaining Tasks
- [ ] Migrate authentication screens to new design system
- [ ] Migrate main navigation screens to new design system
- [ ] Migrate core feature screens to new design system
- [ ] Add comprehensive testing for new components
- [ ] Performance optimization and final polish