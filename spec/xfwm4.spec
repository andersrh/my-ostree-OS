Name:           xfwm4
Version:        4.20.0
Release:        1%{?dist}
Summary:        Xfce window manager

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfwm4/4.20/xfwm4-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libX11-devel
BuildRequires:  libXext-devel
BuildRequires:  libXrandr-devel
BuildRequires:  libXrender-devel
BuildRequires:  libXinerama-devel
BuildRequires:  libXcomposite-devel
BuildRequires:  libXdamage-devel
BuildRequires:  libXfixes-devel
BuildRequires:  libXpresent-devel
BuildRequires:  libwnck3-devel
BuildRequires:  startup-notification-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Xfwm4 is the Xfce window manager.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfwm4

%files -f xfwm4.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfwm4
%{_bindir}/xfwm4-settings
%{_bindir}/xfwm4-tweaks-settings
%{_bindir}/xfwm4-workspace-settings
%{_libdir}/xfce4/xfwm4/
%{_datadir}/applications/xfwm4.desktop
%{_datadir}/applications/xfwm4-settings.desktop
%{_datadir}/applications/xfwm4-tweaks-settings.desktop
%{_datadir}/applications/xfwm4-workspace-settings.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.xfwm4.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.xfwm4-tweaks.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.xfwm4-workspace.png
%{_datadir}/themes/Default/xfwm4/

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
