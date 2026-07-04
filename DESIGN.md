---
name: Civic Integrity
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#454652'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#767683'
  outline-variant: '#c6c5d4'
  surface-tint: '#4c56af'
  primary: '#000666'
  on-primary: '#ffffff'
  primary-container: '#1a237e'
  on-primary-container: '#8690ee'
  inverse-primary: '#bdc2ff'
  secondary: '#7e5700'
  on-secondary: '#ffffff'
  secondary-container: '#feb300'
  on-secondary-container: '#6a4800'
  tertiary: '#001c35'
  on-tertiary: '#ffffff'
  tertiary-container: '#003157'
  on-tertiary-container: '#2c9bf9'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e0e0ff'
  primary-fixed-dim: '#bdc2ff'
  on-primary-fixed: '#000767'
  on-primary-fixed-variant: '#343d96'
  secondary-fixed: '#ffdeac'
  secondary-fixed-dim: '#ffba38'
  on-secondary-fixed: '#281900'
  on-secondary-fixed-variant: '#604100'
  tertiary-fixed: '#d1e4ff'
  tertiary-fixed-dim: '#9ecaff'
  on-tertiary-fixed: '#001d36'
  on-tertiary-fixed-variant: '#00497d'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  headline-lg:
    fontFamily: Roboto Flex
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: 0px
  headline-md:
    fontFamily: Roboto Flex
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: 0px
  title-lg:
    fontFamily: Roboto Flex
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.15px
  body-lg:
    fontFamily: Roboto Flex
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Roboto Flex
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Roboto Flex
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
  label-sm:
    fontFamily: Roboto Flex
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  margin-mobile: 16px
  gutter: 12px
  stack-sm: 4px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style
The design system is engineered for civic utility, prioritizing trust, efficiency, and clarity. It serves a diverse Indonesian population reporting infrastructure issues under a "government-to-citizen" (G2C) model. 

The aesthetic is **Corporate Modern with a Minimalist focus**, adhering closely to Android’s Material Design 3 principles but with a more rigid, professional structure. The UI evokes a sense of officialdom and reliability through a clean, flat design language that avoids unnecessary decorative elements. High contrast and generous whitespace ensure that the app remains functional in outdoor environments (high glare) where users are likely to report road damage.

## Colors
The palette uses **Deep Navy Blue** as the anchor to signify authority and the Indonesian government's institutional presence. **Amber** serves as a functional accent for attention-driving elements like primary actions and "Pending" states.

- **Primary (#1A237E):** Used for App Bars, primary buttons, and active navigation states.
- **Accent (#FFB300):** Reserved for primary call-to-actions (CTAs) and cautionary status indicators.
- **Background (#F5F5F5):** A cool light gray to reduce eye strain and provide separation for white surface cards.
- **Status Semantic Palette:** 
    - *Pending:* Amber (#FFB300)
    - *In Progress:* Blue (#2196F3)
    - *Resolved:* Green (#4CAF50)

## Typography
This design system utilizes **Roboto Flex** for its mechanical efficiency and high legibility on mobile displays. The hierarchy is strictly functional:
- **Headlines:** Use Bold weights for screen titles to establish immediate context.
- **Body:** Uses Regular weight with a standard 16px base for accessibility. 
- **Labels:** Used for status badges, button text (all-caps optional), and form captions.
- **Localization:** Ensure line-height accommodates potential Indonesian word lengths which can be longer than English equivalents.

## Layout & Spacing
The layout follows an **8px grid system** for consistent vertical and horizontal rhythm. 
- **Grid:** A 4-column fluid grid for mobile with 16px outer margins.
- **Touch Targets:** All interactive elements must maintain a minimum 48x48px touch area.
- **Safe Areas:** Adhere to Android system bars (Status bar at top, Navigation bar at bottom).
- **Density:** High information density is preferred for lists of reports, using 12px gutters between cards.

## Elevation & Depth
In line with a **Flat Design** philosophy, this system minimizes the use of heavy shadows. 
- **Surface Layering:** Depth is primarily communicated through color contrast (White surfaces on Light Gray backgrounds).
- **Shadows:** Only used for "Floating Action Buttons" (FAB) and the "Bottom Navigation Bar" to indicate they sit above the content. Use a very soft, 10% opacity black shadow with a 4px blur.
- **Outlines:** Low-contrast 1px strokes (#E0E0E0) are used for card boundaries and input fields instead of elevation to maintain a clean, modern look.

## Shapes
The shape language is **Rounded (8px default)**, providing a friendly touch to a professional government app without appearing "toy-like."
- **Standard Components:** Buttons, input fields, and cards use an 8px (rounded-md) corner radius.
- **Status Badges:** Use a fully rounded/pill-shape to distinguish them from interactive buttons.
- **Photo Upload Zones:** Use a dashed 8px rounded border to indicate a drop/tap zone.

## Components
- **Primary Buttons:** High-emphasis components using the Primary Navy color or Accent Amber for the "Submit" action. Minimum height of 52px.
- **List Cards:** White background, 1px stroke, 8px radius. Should include a title, timestamp, and a status badge in the top right.
- **Status Badges:** Small, pill-shaped containers with a background color corresponding to the status (Amber/Blue/Green) and white text.
- **Input Fields:** Outlined style with a fixed "+62" prefix for phone numbers. Labels remain visible above the field once focused.
- **Summary Chips:** Used at the top of the dashboard to filter by "Type of Damage" (e.g., Pothole, Flood, Crack).
- **Photo Upload:** A large, square 8px rounded container with a camera icon and "Add Photo" label.
- **Bottom Navigation:** A persistent bar featuring icons for "Home," "My Reports," and "Profile," using the Primary color for the active state.
- **Progress Bar:** A thin linear track showing the lifecycle of a report from "Verified" to "Work in Progress" to "Completed."