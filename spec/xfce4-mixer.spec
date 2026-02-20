Name:           xfce4-mixer
Version:        4.20.0
Release:        1%{?dist}
Summary:        Volume control for the Xfce desktop environment

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/apps/xfce4-mixer/4.20/xfce4-mixer-%{version}.tar.xz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  gstreamer1-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
Xfce4-mixer is a volume control application for the Xfce desktop
environment.

%prep
%autosetup

%build
xdt-autogen
%configure
%make_build

%install
%make_install

%find_lang xfce4-mixer

%files -f xfce4-mixer.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-mixer
%{_datadir}/applications/xfce4-mixer.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.mixer.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.mixer.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
