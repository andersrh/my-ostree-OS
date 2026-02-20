Name:           xfce4-screensaver
Version:        4.20.1
Release:        1%{?dist}
Summary:        Screensaver for the Xfce desktop

License:        GPLv2+ and LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/apps/xfce4-screensaver/4.20/xfce4-screensaver-%{version}.tar.xz

BuildRequires:  gcc
BuildRequires:  meson
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libwnck3-devel
BuildRequires:  libX11-devel
BuildRequires:  libXext-devel
BuildRequires:  libXrandr-devel
BuildRequires:  libXScrnSaver-devel
BuildRequires:  libxklavier-devel
BuildRequires:  pam-devel
BuildRequires:  systemd-devel
BuildRequires:  desktop-file-utils
BuildRequires:  gettext

%description
Xfce4-screensaver is a screen saver and locker that is part of the Xfce
desktop environment.

%prep
%autosetup

%build
%meson \
    -Dpam-prefixes=%{_sysconfdir} \
    -Dpam-conf-dir=pam.d
%meson_build

%install
%meson_install

%find_lang xfce4-screensaver

%files -f xfce4-screensaver.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-screensaver
%{_bindir}/xfce4-screensaver-command
%{_bindir}/xfce4-screensaver-configure
%{_bindir}/xfce4-screensaver-preferences
%{_libdir}/xfce4-screensaver/
%{_sysconfdir}/pam.d/xfce4-screensaver
%{_datadir}/applications/org.xfce.ScreenSaver.desktop
%{_datadir}/desktop-directories/xfce-screensaver.directory
%{_datadir}/icons/hicolor/*/apps/org.xfce.ScreenSaver.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.ScreenSaver.svg
%{_datadir}/pixmaps/xfce4-screensaver.png
%{_mandir}/man1/xfce4-screensaver*.1*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.1-1
- Initial release for Xfce 4.20 compatibility
